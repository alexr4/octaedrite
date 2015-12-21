#version 410
uniform mat4 modelview;
uniform mat4 transform;
//uniform mat4 texMatrix; //deprécier un GLSL 4.0
uniform mat3 normalMatrix;

in vec4 vertex;
in vec4 color;
in vec3 normal;
in vec4 texCoord;
in vec4 tangent;

out vec4 vertColor;
out vec4 vertTexCoord;

void main()
{

	vertColor = color;
	vertTexCoord =  texCoord;//texMatrix * vec4(texCoord, 1.0, 1.0);

	gl_Position = transform * vertex;
}