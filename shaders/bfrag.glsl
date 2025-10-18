#version 460
#define PI 3.14159265359

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 FragColor;

in vec2 texCoord;
in vec4 vColor;
in vec2 light;
in vec4 pos;
in vec3 shadowNDCPos;
in mat3 TBN;

uniform mat4 gbufferModelViewInverse;
uniform sampler2D gtexture;
uniform sampler2D normals;
uniform sampler2D lightmap;
uniform sampler2D shadowcolor0;
uniform sampler2D shadowcolor1;
uniform sampler2D shadowtex0;
uniform vec3 shadowLightPosition;

float getShadow(sampler2D shadowInfo, vec2 coord) 
{
	vec2 m1m2 = texture(shadowInfo, coord).rg;
	float sigma2 = m1m2.y - m1m2.x * m1m2.x;
	sigma2 = max(sigma2, 0.000001);

	float t = shadowNDCPos.z;
	float p = (t <= m1m2.x) ? 1. : 0.;

	float t_m = t - m1m2.x;
	float pmax = sigma2 / (sigma2 + t_m * t_m);

	float shadow = max(p, pmax);
	float Amount = 0.6;
	shadow = smoothstep(Amount, 1., shadow);
	return shadow;
}

void main() {
	float shadow = getShadow(shadowcolor0, shadowNDCPos.xy);

	vec4 pluh = texture(gtexture, texCoord);
	if (pluh.w >= 0.2) {
		vec3 blockColor = pluh.xyz * vColor.xyz;
		vec3 blocklight = texture(lightmap, vec2(light.x, 1/32.)).xyz;
		vec3 skylight = texture(lightmap, vec2(1/32., light.y)).xyz;
		vec3 ambient = blocklight + 0.2 * skylight;

		vec3 tNorm = texture(normals, texCoord).xyz;
		float ao = sqrt(1. - dot(tNorm.xy, tNorm.xy));
		tNorm.z = ao;
		tNorm = tNorm * 2. -1.;
		vec3 norm = TBN * tNorm;

		vec3 lightDir = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);
		float light = max(0.2, dot(lightDir, normalize(norm)));

		FragColor = vec4(blockColor * ambient + skylight * shadow * blockColor * light * 0.8, pluh.w * vColor.w);
	}
	else discard;
}
