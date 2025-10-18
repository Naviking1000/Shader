#version 460 compatibility

out vec2 texCoord;

void main() {
  texCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
  gl_Position = ftransform();
}
