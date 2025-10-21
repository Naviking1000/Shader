#version 460 compatibility
#include "gauss.glsl"

uniform sampler2D shadowcolor0;
uniform sampler2D shadowcolor1;
uniform sampler2D shadowcolor2;
uniform sampler2D shadowcolor3;

in vec2 texCoord;

layout(location = 0) out vec4 color0;
layout(location = 1) out vec4 color1;
layout(location = 2) out vec4 color2;
layout(location = 3) out vec4 color3;

void main() {
	color0 = getGaussian(shadowcolor0, texCoord, true, SAMPLES);
	color1 = texture(shadowcolor1, texCoord);
	color2 = texture(shadowcolor2, texCoord);
	color3 = texture(shadowcolor3, texCoord);
}
