#version 150
#define PROCESSING_TEXTURE_SHADER

uniform mat4 modelview;
uniform mat4 transform;
uniform mat4 texMatrix;
uniform mat3 normalMatrix;

attribute vec4 vertex;
attribute vec4 color;
attribute vec3 normal;
attribute vec2 texCoord;
attribute vec4 tangent;

varying vec4 vertColor;
varying vec4 vertTexCoord;


void main()
{

	vertColor = color;
	vertTexCoord =  texMatrix * vec4(texCoord, 1.0, 1.0);

	gl_Position = transform * vertex;
}