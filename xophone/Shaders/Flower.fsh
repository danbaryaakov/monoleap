void main(){
    vec2 pos = gl_FragCoord.xy / u_resolution;
    pos.x -= 0.5;
    pos.y -= 0.5;
//    pos.y -= u.resolution.y;

    const float pi = 3.14159;
    const float n = 20.0;

    
    pos.x += sin(u_time + pos.x*pos.y*4.0+pos.x)*0.1;
    
    float v = sin(pos.y+u_time*0.4);
    
    float radius = length(pos)*4.0 - (1.+v);
    float t = atan(pos.y, pos.x)/pi;
    
    float color = 0.3 + sin(length(pos)+pos.y*4.0+u_time)*0.4;
    for (float i = 0.0; i < n; i++){
        color += 0.003/abs(0.8*sin(6.0*pi*(t + i/n*u_time*0.05)) - radius);
    }
    
    gl_FragColor = vec4(vec3(1.6, .91, 0.65) * color, 0) * SKDefaultShading();
    
}
