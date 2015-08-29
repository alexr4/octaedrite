#version 150
#define PROCESSING_TEXLIGHT_SHADER

uniform mat4 modelview;
uniform mat4 transform;
uniform mat4 texMatrix;
uniform mat3 normalMatrix;

uniform vec4 lightPosition;
uniform vec3 lightNormal;

attribute vec4 vertex;
attribute vec4 color;
attribute vec3 normal;
attribute vec2 texCoord;
attribute vec4 tangent;

varying vec4 vertColor;
varying vec4 vertTexCoord;
varying vec3 ecNormal;
varying vec3 ecVertex;
varying vec3 lightDir;
varying vec3 viewDir;

void main()
{

	ecVertex = vec3(modelview * vertex);
	ecNormal = normalize(normalMatrix * normal);
	lightDir = normalize(lightPosition.xyz - ecVertex);

	vertColor = color;
	vertTexCoord =  texMatrix * vec4(texCoord, 1.0, 1.0);

	gl_Position = transform * vertex;
}