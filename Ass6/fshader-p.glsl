#version 120

//Phong shading fragment shader
varying vec3 vertexLight;
varying vec3 normal;
varying vec3 vertex;
varying vec3 veiwer;
varying vec3 reflected;


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
	vec3 lightvec = normalize(vertexLight);
	vec3 normalvec = normalize(normal);
	float LN =  dot(lightvec,normalvec);
	
	float red = 0.89 * 0.7 * LN ;
	float green = 0.0 * 0.7 * LN;
	float blue = 0.0 * 0.7 * LN;
	 
    return vec3(red,green,blue);
}

vec3 GetSpec()
{
	vec3 vecViewer = normalize(veiwer);
	vec3 vecReflect =normalize(reflected);
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
	
    float red = ambient.x + diffuse.x + specular.x ;
    float green = ambient.y + diffuse.y + specular.y;
    float blue = ambient.z + diffuse.z + specular.z;
    
    gl_FragColor = vec4( red, green, blue, 1.0 );
}
