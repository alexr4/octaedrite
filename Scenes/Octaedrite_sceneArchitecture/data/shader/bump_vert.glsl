#version 150
#define PROCESSING_TEXLIGHT_SHADER

uniform mat4 modelview;
uniform mat4 transform;
uniform mat4 texMatrix;
uniform mat3 normalMatrix;


uniform int lightCount;
uniform vec4 lightPosition[8];
uniform vec3 lightNormal[8];

attribute vec4 vertex;
attribute vec4 color;
attribute vec3 normal;
attribute vec2 texCoord;
attribute vec4 tangent;

varying vec4 vertColor;
varying vec4 vertTexCoord;
varying vec3 ecNormal;
varying vec3 ecVertex;
varying vec3 lightDir[8];
varying vec3 viewDir;

void main()
{

	ecVertex = vec3(modelview * vertex);
	ecNormal = normalize(normalMatrix * normal);

	for(int i = 0 ;i < lightCount ;i++) { 
     lightDir[i] = normalize(lightPosition[i].xyz - ecVertex);
  	}

	vertColor = color;
	vertTexCoord =  texMatrix * vec4(texCoord, 1.0, 1.0);

	gl_Position = transform * vertex;
}