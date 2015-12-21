#version 410

uniform sampler2D diffuse;
uniform sampler2D mask;
uniform sampler2D bumpmap;
//uniform sampler2D displacement;

uniform int lightCount;// = 8;
uniform vec3 lightNormal[8];
uniform vec4 lightPosition[8];
// diffuse is the color element of the light
uniform vec3 lightDiffuse[8];

in vec4 vertColor;
in vec4 vertTexCoord;
in vec3 ecNormal;
in vec3 ecVertex;
in vec3 lightDir[8];

//material
uniform vec3 kd;//Diffuse reflectivity
uniform vec3 ka;//Ambient reflectivity
uniform vec3 ks;//Specular reflectivity
uniform float shininess;//shine factor
uniform vec3 emissive;
uniform float minNormalEmissive;
uniform float alphaAlbedo;

out vec4 fragColor;

vec3 ads(vec3 dir, vec3 color)
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
	vec4 texdiffuse = texture2D(diffuse, vertTexCoord.xy).rgba;
	//vec4 texdisplacement = texture2D(displacement, vertTexCoord.xy);
	vec4 texmask = texture2D(mask, vertTexCoord.xy).rgba;
	vec4 texbump = texture2D(bumpmap, vertTexCoord.xy).rgba;
	vec3 normalmap = vec3(texbump.xyz) * 2.0 - 1.0; 

	//lights
	vec3 norm = normalize(normalmap);
	float intensityNormalMap = 0.0;
	vec4 lightColor = vec4(0.0, 0.0, 0.0, 1.0);
	
	for(int i = 0 ; i <  lightCount ; i++) 
	{
	  vec3 direction = normalize(lightDir[i]);
	  lightColor += vec4(ads(direction, lightDiffuse[i].xyz), 1.0);
	  intensityNormalMap += max(dot(norm, lightDir[i]), minNormalEmissive);
	}
	intensityNormalMap = intensityNormalMap/lightCount;
	vec4 diffuse = vec4(texdiffuse.rgb, 1.0) * intensityNormalMap;
	vec4 final_light_color =  vec4(emissive, 1.0)  +  lightColor * vertColor;

	vec4 albedo = vec4(diffuse.xyz, texmask.r * alphaAlbedo) * vec4(final_light_color.rgb, alphaAlbedo);

	fragColor = albedo;
}
