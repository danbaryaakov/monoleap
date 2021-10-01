vec2 complexMultiplication(in highp vec2 left, in highp vec2 right)
{
    return vec2((left.x * right.x) - (left.y * right.y), (left.x * right.y) + (left.y * right.x));
}

float sqrMagnitude(in highp vec2 z)
{
    return (z.x * z.x) + (z.y * z.y);
}

vec2 complexPower(in highp vec2 left, in highp vec2 right)
{
    float magnitude_squared = sqrMagnitude(left);
    float l = pow(magnitude_squared, right.x * 0.5) * exp(-right.y * atan(left.y, left.x));
    float r = (right.x * atan(left.y, left.x)) + (0.5 * right.y * log(magnitude_squared));
    return vec2(l * cos(r), l * sin(r));
}

vec3 julia(in highp vec2 position, highp float power)
{
    highp vec2 z = vec2(0.0, 0.0);
    const vec3 colors[30] = vec3[30]
    (
        vec3(0.1, 0.0, 0.9),
        vec3(0.2, 0.0, 0.8),
        vec3(0.3, 0.0, 0.7),
        vec3(0.4, 0.0, 0.6),
        vec3(0.5, 0.0, 0.5),
        vec3(0.6, 0.0, 0.4),
        vec3(0.7, 0.0, 0.3),
        vec3(0.8, 0.0, 0.2),
        vec3(0.9, 0.0, 0.1),
        vec3(1.0, 0.0, 0.0),
        vec3(0.9, 0.1, 0.0),
        vec3(0.8, 0.2, 0.0),
        vec3(0.7, 0.3, 0.0),
        vec3(0.6, 0.4, 0.0),
        vec3(0.5, 0.5, 0.0),
        vec3(0.4, 0.6, 0.0),
        vec3(0.3, 0.7, 0.0),
        vec3(0.2, 0.8, 0.0),
        vec3(0.1, 0.9, 0.0),
        vec3(0.0, 1.0, 0.0),
        vec3(0.0, 0.9, 0.1),
        vec3(0.0, 0.8, 0.2),
        vec3(0.0, 0.7, 0.3),
        vec3(0.0, 0.6, 0.4),
        vec3(0.0, 0.5, 0.5),
        vec3(0.0, 0.4, 0.6),
        vec3(0.0, 0.3, 0.7),
        vec3(0.0, 0.2, 0.8),
        vec3(0.0, 0.1, 0.9),
        vec3(0.0, 0.0, 1.0)
    );
    for (int i = 0, j; i < 1024; i++)
    {
        z = complexPower(z, vec2(power, 0.0)) + position;
        if (sqrMagnitude(z) > 4.0)
        {
            return colors[i % colors.length()];
        }
    }
    return vec3(0.0, 0.0, 0.0);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord )
{
    float time = iTime;
    bool reverse = false;
    const float max_zoom = 16.0;
    while (time >= max_zoom)
    {
        time -= max_zoom;
        reverse = !reverse;
    }
    time = (reverse ? (max_zoom - time) : time);
    float zoom = exp(time) * 0.75;
    vec2 start_center = vec2(0.0, 0.0);
    vec2 target_center = vec2(-0.745428, 0.113009);
    float t = clamp(time, 0.0, 1.0);
    vec2 center = mix(start_center, target_center, t);
    float power = 2.0;
    vec2 position = vec2((((fragCoord.x * 3.0 / iResolution.x) - 2.0) / zoom) + center.x, (((fragCoord.y * 2.0 / iResolution.y) - 1.0) / zoom) + center.y);
    vec2 position_offset = vec2(((((fragCoord.x + 0.5) * 3.0 / iResolution.x) - 2.0) / zoom) + center.x, ((((fragCoord.y + 0.5) * 2.0 / iResolution.y) - 1.0) / zoom) + center.y) - position;
    vec3 color = julia(position, power);
    vec3 sum_sub_colors =
        julia(vec2(position.x + position_offset.x, position.y), power) +
        julia(vec2(position.x - position_offset.x, position.y), power) +
        julia(vec2(position.x, position.y + position_offset.y), power) +
        julia(vec2(position.x, position.y - position_offset.y), power) +
        julia(vec2(position.x + position_offset.x, position.y + position_offset.y), power) +
        julia(vec2(position.x - position_offset.x, position.y + position_offset.y), power) +
        julia(vec2(position.x + position_offset.x, position.y - position_offset.y), power) +
        julia(vec2(position.x - position_offset.x, position.y - position_offset.y), power);
    fragColor = vec4(vec3(sum_sub_colors.x * 0.0625, sum_sub_colors.y * 0.0625, sum_sub_colors.z * 0.0625) + vec3(color.x * 0.5, color.y * 0.5, color.z * 0.5), 1.0);
}
