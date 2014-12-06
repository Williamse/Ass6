#version 120

// Gouraud shading fragment shader
varying float red;
varying float green;
varying float blue;
void main()
{
    gl_FragColor = vec4( red, green, blue, 1.0 );
}
