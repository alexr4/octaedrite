#version 410
uniform mat4 modelview;
uniform mat4 transform;
uniform mat4 texMatrix;
uniform mat3 normalMatrix;


uniform int lightCount;
uniform vec4 lightPosition[8];
uniform vec3 lightNormal[8];

in vec4 vertex;
in vec4 color;
in vec3 normal;
in vec4 texCoord;
in vec4 tangent;

out vec4 vertColor;
out vec4 vertTexCoord;
out vec3 ecNormal;
out vec3 ecVertex;
out vec3 lightDir[8];
out vec3 viewDir;

void main()
{

	ecVertex = vec3(modelview * vertex);
	ecNormal = normalize(normalMatrix * normal);

	for(int i = 0 ;i < lightCount ;i++) { 
     lightDir[i] = normalize(lightPosition[i].xyz - ecVertex);
  	}

	vertColor = color;
	vertTexCoord =  texCoord;//texMatrix * vec4(texCoord, 1.0, 1.0);

	gl_Position = transform * vertex;
}
