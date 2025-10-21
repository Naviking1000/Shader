#version 460 compatibility
#include "consts.glsl"

uniform sampler2D shadowtex0;
uniform sampler2D shadowcolor1;
uniform sampler2D shadowcolor2;
uniform sampler2D shadowcolor3;

in vec2 texCoord;

layout(location = 0) out vec4 color0;
layout(location = 1) out vec4 color1;
layout(location = 2) out vec4 color2;
layout(location = 3) out vec4 color3;

void main() {
	highp float sunDepth = texture(shadowtex0, texCoord).r;
  color0.x = exp(sunDepth * C);
	color0.y = color0.x * color0.x;
	color0.z = -exp(-sunDepth * CNEG);
	color0.a = color0.z * color0.z;

	color1 = texture(shadowcolor1, texCoord);
	color2 = texture(shadowcolor2, texCoord);
	color3 = texture(shadowcolor3, texCoord);
}
