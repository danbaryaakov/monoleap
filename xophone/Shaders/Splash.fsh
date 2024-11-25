
vec2 hash(vec2 p)
{
    mat2 m = mat2(  443.85, 447.77,
                    949.41, 18.48
                );

    return fract(sin(m*m*m*p*p) * 11138.29);
}

float voronoi(vec2 p)
{
    vec2 g = floor(p);
    vec2 f = fract(p);

    float distanceToClosestFeaturePoint = 1.0;
    for(int y = -1; y <= 1; y++)
    {
        for(int x = -1; x <= 1; x++)
        {
            vec2 latticePoint = vec2(x, y);
            float currentDistance = distance(latticePoint - hash(g*latticePoint), f);
            distanceToClosestFeaturePoint = min(distanceToClosestFeaturePoint, currentDistance);
        }
    }

    return distanceToClosestFeaturePoint;
}

void main( void )
{
    vec2 uv = ( gl_FragCoord.xy / u_resolution.xy ) * 2.0 - 1.0;
    uv.y *= u_resolution.x / u_resolution.y;

    float offset = voronoi(uv*10.0 * vec2(u_time-uv-uv-u_time));
    float t = 1.0/abs(((uv.x + sin(uv.y + u_time)) + offset) * 30.0);

    float r = voronoi( uv * 1.0 ) * 10.0;
    vec3 finalColor = vec3(11.0 * uv.y, 2.0, 1.0 * r *uv.y *r * uv.x) * t;
    
    gl_FragColor = vec4(finalColor+finalColor, 0 ) * SKDefaultShading();
}
