#version 120

// Flat shading fragment shader

varying	vec4 color;	
varying float red;
varying float green;
varying float blue;

void main()
{
    //gl_FragColor = vec4( 1.0, 1.0, 1.0, 1.0 );
  // gl_FragColor = vec4 (0.0, 1.0, 0.0, 1.0);
//	gl_FragColor = color;
  gl_FragColor = vec4(red,green,blue,1.0);

}
