
void main(){
    vec2 coord = (gl_FragCoord.xy / u_resolution);
    vec3 color = u_color;

    float angle = atan(-coord.y + 0.25, coord.x - 0.5) * 0.1;
    float len = length(coord - vec2(0.5, 0.5));

    color.r += sin(len * u_speed + angle * 40.0 + u_time * 0.5);
    color.g += cos(len * u_speed + angle * 50.0 - u_time * 0.5);
    
//  color.r += sin(len * 40.0 + angle * 40.0 + u_time);
//  color.g += cos(len * 30.0 + angle * 60.0 - u_time);
//  color.b += sin(len * 50.0 + angle * 50.0 + 3.0);

    gl_FragColor = vec4(color, 0.0) * SKDefaultShading();
}
