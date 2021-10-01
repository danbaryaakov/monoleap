
void main(){
    vec4 current_color = SKDefaultShading();
    
    vec2 coord = 6.0 * gl_FragCoord.xy / u_resolution;

    int iterations = u_playing == 1.0 ? 13 : 12;
    
    for (int n = 1; n < iterations; n++){
        float i = float(n);
        coord += vec2(0.7 / i * sin(i * coord.y + u_time * u_speed  + 0.1 * i) + 0.8, 0.4 / i * sin(coord.x + u_time * u_speed + 0.1 * i) + 1.6);
    }

//    if (u_playing == 1.0) {
//        coord *= vec2(0.7 / sin(coord.y + u_time + 0.3) + 0.8, 0.4 / sin(coord.x + u_time + 0.3) + 1.6);
//    }

    vec3 color = vec3(0.5 * sin(coord.x) + 0.5, 0.5 * sin(coord.y) + 0.5, sin(coord.x + coord.y));
    
    gl_FragColor = vec4(color, 0) * current_color;
}
