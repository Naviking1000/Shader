#version 460 compatibility

in vec3 vaNormal;

uniform mat4 gbufferModelViewInverse;
uniform mat3 normalMatrix;

out vec2 texcoord;
out vec4 glcolor;
out vec3 pos;
out vec3 norm;

void main() {
  texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
  glcolor = gl_Color;
  gl_Position = ftransform();
	pos = gl_Position.xyz;
	norm = normalize(gl_NormalMatrix * gl_Normal);

	float distortionFactor = length(gl_Position.xy); 
	distortionFactor += 0.1; 

	gl_Position.xy /= distortionFactor;
	gl_Position.z *= 0.5; // increases shadow distance on the Z axis, which helps when the sun is very low in the sky
}
