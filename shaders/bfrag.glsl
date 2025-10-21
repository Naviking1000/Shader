#version 460
#include "consts.glsl"

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 FragColor;

in vec2 texCoord;
in vec4 vColor;
in vec2 light;
in vec4 pos;
in vec3 shadowNDCPos;
in vec3 shadowModelViewPos;
in mat3 TBN;

uniform sampler2D shadowtex0; //sun depth
uniform sampler2D shadowcolor0; //depth moments
uniform sampler2D shadowcolor1; //PL radiant flux
uniform sampler2D shadowcolor2; //PL normal (direction)
uniform sampler2D shadowcolor3; //PL position

uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform sampler2D gtexture;
uniform sampler2D normals;
uniform sampler2D lightmap;
uniform vec3 shadowLightPosition;

float cheb(vec2 moments, float c, float sig, float depth)
{
	float t = sig * exp(sig * c * depth);
	float depthScale = 0.0001 * c * t;

	float sigma2 = moments.y - moments.x * moments.x;
	sigma2 = max(sigma2, depthScale * depthScale);

	float p = (t <= moments.x) ? 1. : 0.;

	float t_m = t - moments.x;
	float pmax = sigma2 / (sigma2 + t_m * t_m);

	return max(p, pmax);
}

float getShadow(sampler2D shadowInfo, vec2 coord) 
{
	vec4 moments = texture(shadowInfo, coord);

	float shadow = min(cheb(moments.zw, CNEG, -1., shadowNDCPos.z), cheb(moments.xy, C, 1., shadowNDCPos.z));

	return smoothstep(0.2, 1., shadow);
}

void main() {

	vec4 pluh = texture(gtexture, texCoord);
	if (pluh.w >= 0.2) {
		vec3 blockColor = pluh.xyz * vColor.xyz;
		vec3 blocklight = texture(lightmap, vec2(light.x, 1/32.)).xyz;
		vec3 skylight = texture(lightmap, vec2(1/32., light.y)).xyz;
		vec3 ambient = blocklight + 0.2 * skylight;

		vec3 tNorm = texture(normals, texCoord).xyz;
		float ao = sqrt(1. - dot(tNorm.xy, tNorm.xy));
		tNorm = tNorm * 2. -1.;
		tNorm.xy *= 0.5;
		vec3 norm = TBN * tNorm;

		vec3 lightDir = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);
		float light = max(0.2, dot(lightDir, normalize(norm)));

		float shadow = getShadow(shadowcolor0, shadowNDCPos.xy);

		FragColor = vec4(blockColor * ambient + skylight * shadow * blockColor * light, pluh.w * vColor.w);
		// FragColor = vec4(texture(shadowcolor2, shadowNDCPos.xy).xyz, 1.);
		// FragColor = vec4(mat3(shadowModelView) * norm, 1.);
	}
	else discard;
}
