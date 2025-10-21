#define SAMPLES 2
vec4 getGaussian(sampler2D shadow, vec2 coord, bool axis, int samples)
{
	float total = 0.;
	vec4 result = vec4(0.);
	vec2 texelSize = 1.0 / textureSize(shadow, 0);
	for (int i = -samples; i <= samples; i++)
	{
		vec2 offset = vec2(0.);
		if (axis)
			offset = vec2(0., i);
		else
			offset = vec2(i, 0.);

		float gaussP = coord.x + i * 0.1;
		float gauss = 0.398942280401 * exp(-(gaussP * gaussP)/2.);

		vec4 sampled = texture(shadow, coord + offset * texelSize) * gauss;

		result += sampled;
		total += gauss;
	}
	result /= total;
	return result;
}
