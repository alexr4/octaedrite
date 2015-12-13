#version 150
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D stencil;

varying vec4 vertColor;
varying vec4 vertTexCoord;


void main()
{
	vec4 texdiffuse = texture2D(stencil, vertTexCoord.st);


	gl_FragColor =texdiffuse;
}