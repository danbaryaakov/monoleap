void main() {
    vec2 p = ( gl_FragCoord.xy / u_resolution.xy-0.5 )*4.0;
    
    p = floor(16.*p)/16.0;
    float X = p.x;
    float Y = p.y;
    float t = u_time/3.;
    gl_FragColor = vec4( vec3( sin(t*2.+X*X-Y*Y), cos(t*4.+X*Y), sin(t*6.+X*X+Y*Y)), 0.0 ) * SKDefaultShading();

}
