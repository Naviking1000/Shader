#version 460 compatibility
#include "gauss.glsl"

uniform sampler2D shadowcolor0;

in vec2 texCoord;

layout(location = 0) out vec4 color;

void main() {
	color = texture(shadowcolor0, texCoord);
	color = vec4(getGaussian(shadowcolor0, texCoord, true, SAMPLES), 0., 1.);
}
