#version 460 compatibility

const int shadowMapResolution = 1024;
const bool shadowtex0Nearest = true;
const bool shadowtex1Nearest = true;
const float sunPathRotation = -25.;
/*
const int shadowcolor0Format = RGBA32F;
*/

uniform sampler2D gtexture;

in vec2 texcoord;
in vec4 glcolor;
in vec3 pos;
in vec3 norm;

/* DRAWBUFFERS:123 */
layout(location = 0) out vec4 color1;
layout(location = 1) out vec4 color2;
layout(location = 2) out vec4 color3;

void main() {
  color1 = texture(gtexture, texcoord) * glcolor;
  if(color1.a < 0.1){
    discard;
  }
	color2 = vec4(norm, 1.);
	color3 = vec4(pos, 1.);
}
