#version 410

uniform sampler2D stencil;

in vec4 vertColor;
in vec4 vertTexCoord;

out vec4 fragColor;

void main()
{
	vec4 texdiffuse = texture2D(stencil, vertTexCoord.xy).rgba;
	fragColor = texdiffuse;
}