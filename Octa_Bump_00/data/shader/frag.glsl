#version 150
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform sampler2D mask;
uniform sampler2D bumpmap;
uniform sampler2D displacement;

varying vec4 vertColor;
varying vec4 vertTexCoord;
varying vec3 ecNormal;
varying vec3 ecVertex;
varying vec3 lightDir;
uniform vec3 lightDiffuse;

//material
uniform vec3 kd;//Diffuse reflectivity
uniform vec3 ka;//Ambient reflectivity
uniform vec3 ks;//Specular reflectivity
uniform float shininess;//shine factor
uniform vec3 emissive;
uniform float minNormalEmissive;

vec3 ads(vec3 dir, vec3 color, vec3 normalmap)
{
	vec3 n = normalize(ecNormal);// * normalmap);
	vec3 s = normalize(dir);
	vec3 v = normalize(-ecVertex.xyz);
	vec3 r = reflect(-s, n);
	vec3 h = normalize(v + s);
	float intensity = max(0.0, dot(s, n));

	//return color * intensity * (ka + kd * max(dot(s, n), 0.0) + ks * pow(max(dot(r, v), 0.0), shininess));
	return color * intensity * (ka + kd * max(dot(s, ecNormal), 0.0) + ks * pow(max(dot(h, n), 0.0), shininess));
}

void main()
{
	vec3 direction = normalize(lightDir);

	vec4 texdiffuse = texture2D(texture, vertTexCoord.st);
	vec4 texdisplacement = texture2D(displacement, vertTexCoord.st);
	vec4 texmask = texture2D(mask, vertTexCoord.st);
	vec4 texbump = texture2D(bumpmap, vertTexCoord.st);
	vec3 normalmap = vec3(texbump.xyz) * 2.0 - 1.0; 

	vec3 norm = normalize(normalmap);
	float intensityNormalMap = max(dot(norm, lightDir), minNormalEmissive);
	vec4 diffuse = vec4(texdiffuse.rgb, 1.0) * intensityNormalMap;

	vec4 lightColor = vec4(ads(direction, lightDiffuse.xyz, norm), 1.0);
	vec4 final_light_color =  vec4(emissive, 1.0)  +  lightColor * vertColor;

	gl_FragColor = vec4(diffuse.xyz, texmask.r) * final_light_color;
}