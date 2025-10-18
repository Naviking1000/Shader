#version 460

in vec3 vaPosition;
in vec2 vaUV0;
in vec4 vaColor;
in ivec2 vaUV2;
in vec3 vaNormal;
in vec4 at_tangent;

uniform mat4 gbufferProjectionInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjection;
uniform mat3 normalMatrix;
uniform vec3 chunkOffset;

out vec2 texCoord;
out vec4 vColor;
out vec2 light;
out vec4 pos;
out vec3 shadowNDCPos;
out mat3 TBN;

vec4 distort(vec4 shadowNDCPosHom) {
	shadowNDCPosHom.z *= 0.5;
	float distortionFactor = length(shadowNDCPosHom.xy); 
	distortionFactor += 0.1; 
	shadowNDCPosHom.xy /= distortionFactor;

	return shadowNDCPosHom;
}

vec3 getShadowCoords(vec3 fragPos) {
	vec3 shadowModelViewPos = (shadowModelView * vec4(fragPos, 1.)).xyz;
	vec4 shadowNDCPosHom = shadowProjection * vec4(shadowModelViewPos, 1.);

	shadowNDCPosHom = distort(shadowNDCPosHom);
	shadowNDCPosHom.z += 0.000001;

	vec3 shadowNDCPos = (shadowNDCPosHom.xyz / shadowNDCPosHom.w) * 0.5 + 0.5;
	return shadowNDCPos;
}

void main() {
	vColor = vaColor;
	light = vaUV2 * (1. / 256.) + (1. / 32.);
	vec3 norm = mat3(gbufferModelViewInverse) * normalMatrix * vaNormal;
	vec3 tangent = mat3(gbufferModelViewInverse) * at_tangent.xyz;
	TBN = mat3(tangent, cross(tangent, norm), norm);
#ifdef HAND
	texCoord = vaUV0;
	pos = gl_ProjectionMatrix * vec4(mat3(gbufferModelViewInverse) * (gbufferModelView * vec4(vaPosition, 1.)).xyz, 1.);
#endif
#ifdef PARTICLE
	texCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	pos = gl_ProjectionMatrix * gl_ModelViewMatrix * gl_Vertex;
#endif
#ifdef OTHER
	texCoord = vaUV0;
	pos = gbufferProjection * gbufferModelView * vec4(vaPosition + chunkOffset, 1.);
#endif
	gl_Position = pos;

	vec3 fragPos = (gbufferProjectionInverse * pos).xyz;
	fragPos = (gbufferModelViewInverse * vec4(fragPos, 1.)).xyz;

	shadowNDCPos = getShadowCoords(fragPos);
}
