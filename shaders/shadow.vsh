#version 460 compatibility

out vec2 texcoord;
out vec4 glcolor;

void main() {
  texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
  glcolor = gl_Color;
  gl_Position = ftransform();

	float distortionFactor = length(gl_Position.xy); 
	distortionFactor += 0.1; 

	gl_Position.xy /= distortionFactor;
	gl_Position.z *= 0.5; // increases shadow distance on the Z axis, which helps when the sun is very low in the sky
}
