#version 460 compatibility
#include "gauss.glsl"

uniform sampler2D shadowtex0;

in vec2 texCoord;

layout(location = 0) out vec4 shadowcolor0;

void main() {
  shadowcolor0.x = texture(shadowtex0, texCoord).r;
	shadowcolor0.y = shadowcolor0.x * shadowcolor0.x;
}
