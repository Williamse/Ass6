#version 120

// Gouraud shading vertex shader

// INCOMING DATA

// Vertex location (in model space)
attribute vec4 vPosition;

// Normal vector at vertex (in model space)
attribute vec3 vNormal;

// Model transformations
uniform vec3 theta;
uniform vec3 trans;
uniform vec3 scale;

// Camera parameters
uniform vec3 cPosition;
uniform vec3 cLookAt;
uniform vec3 cUp;

// View volume boundaries
uniform float left;
uniform float right;
uniform float top;
uniform float bottom;
uniform float near;
uniform float far;

//mydata
varying	vec4 color;	
varying float red;
varying float green;
varying float blue;


// OUTGOING DATA

vec3 GetPointToLightVec()
{
    vec4 sunloc = vec4(0.0, 5.0, 2.0, 1.0);
    return  (sunloc -vPosition).xyz;
}

vec3 GetPointToviwerVec()
{
    return normalize(cPosition.xyz) - vPosition.xyz;
}
vec3 ReflectedLight()
{

	return normalize(reflect(normalize(-GetPointToLightVec()),normalize(vNormal)));
}
//Returns a vector containg the ambient color calculations in the form [ambient red,ambient green, ambient blue]
vec3 GetAmbient()
{
	float red = 0.5 * 0.5;
	float green = 0.1 * 0.5;
	float blue = 0.9 * 0.5;
	 
    return vec3(red,green,blue);
}

//Returns a vector containg the ambient color calculations in the form [ambient red,ambient green, ambient blue]
vec3 GetDiffuse()
{
	vec3 lightvec = normalize(GetPointToLightVec());
	vec3 normalvec = normalize(vNormal);
	float LN =  dot(lightvec,normalvec);
	
	float red = 0.89 * 0.7 * LN ;
	float green = 0.0 * 0.7 * LN;
	float blue = 0.0 * 0.7 * LN;
	 
    return vec3(red,green,blue);
}

vec3 GetSpec()
{
	vec3 vecViewer = normalize(GetPointToviwerVec());
	vec3 vecReflect = normalize(ReflectedLight());
	float dotted = dot(vecReflect,vecViewer);
	float power  = pow(max(dotted,0),10.0);

	float rightEquation = power;
	
	float red = 1.0 * 1.0  * rightEquation;
	float green = 1.0 * 1.0  * rightEquation;
	float blue = 1.0 * 1.0  * rightEquation;
	
	
	return vec3(red,green,blue);
}

void main()
{
	
	vec3 ambient = GetAmbient();
	vec3 diffuse = GetDiffuse();
	vec3 specular = GetSpec();
	
    red = ambient.x + diffuse.x + specular.x ;
    green = ambient.y + diffuse.y + specular.y;
    blue = ambient.z + diffuse.z + specular.z;
    
    // Compute the sines and cosines of each rotation about each axis
    vec3 angles = radians( theta );
    vec3 c = cos( angles );
    vec3 s = sin( angles );

    // Create rotation matrices
    mat4 rxMat = mat4( 1.0,  0.0,  0.0,  0.0,
                       0.0,  c.x,  s.x,  0.0,
                       0.0,  -s.x, c.x,  0.0,
                       0.0,  0.0,  0.0,  1.0 );

    mat4 ryMat = mat4( c.y,  0.0,  -s.y, 0.0,
                       0.0,  1.0,  0.0,  0.0,
                       s.y,  0.0,  c.y,  0.0,
                       0.0,  0.0,  0.0,  1.0 );

    mat4 rzMat = mat4( c.z,  s.z,  0.0,  0.0,
                       -s.z, c.z,  0.0,  0.0,
                       0.0,  0.0,  1.0,  0.0,
                       0.0,  0.0,  0.0,  1.0 );

    mat4 xlateMat = mat4( 1.0,     0.0,     0.0,     0.0,
                          0.0,     1.0,     0.0,     0.0,
                          0.0,     0.0,     1.0,     0.0,
                          trans.x, trans.y, trans.z, 1.0 );

    mat4 scaleMat = mat4( scale.x,  0.0,     0.0,     0.0,
                          0.0,      scale.y, 0.0,     0.0,
                          0.0,      0.0,     scale.z, 0.0,
                          0.0,      0.0,     0.0,     1.0 );

    // Create view matrix
    vec3 nVec = normalize( cPosition - cLookAt );
    vec3 uVec = normalize( cross (normalize(cUp), nVec) );
    vec3 vVec = normalize( cross (nVec, uVec) );

    mat4 viewMat = mat4( uVec.x, vVec.x, nVec.x, 0.0,
                         uVec.y, vVec.y, nVec.y, 0.0,
                         uVec.z, vVec.z, nVec.z, 0.0,
                         -1.0*(dot(uVec, cPosition)),
                         -1.0*(dot(vVec, cPosition)),
                         -1.0*(dot(nVec, cPosition)), 1.0 );

    // Create projection matrix
    mat4 projMat = mat4( (2.0*near)/(right-left), 0.0, 0.0, 0.0,
                         0.0, ((2.0*near)/(top-bottom)), 0.0, 0.0,
                         ((right+left)/(right-left)),
                         ((top+bottom)/(top-bottom)),
                         ((-1.0*(far+near)) / (far-near)), -1.0,
                         0.0, 0.0, ((-2.0*far*near)/(far-near)), 0.0 );

    // Transformation order:
    //    scale, rotate Z, rotate Y, rotate X, translate
    mat4 modelMat = xlateMat * rxMat * ryMat * rzMat * scaleMat;
    mat4 modelViewMat = viewMat * modelMat;

    // Transform the vertex location into clip space
    gl_Position =  projMat * viewMat  * modelMat * vPosition;
}
