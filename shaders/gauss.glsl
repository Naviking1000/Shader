#define SAMPLES 15
vec2 getGaussian(sampler2D shadow, vec2 coord, bool axis, int samples)
{
	float total = 0.;
	vec2 result = vec2(0.);
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

		vec2 sampled = texture(shadow, coord + offset * texelSize).rg * gauss;

		result += sampled;
		total += gauss;
	}
	result /= total;
	return result;
}
