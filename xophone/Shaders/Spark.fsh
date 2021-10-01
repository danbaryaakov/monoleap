void main( void )
{
    vec2 pos = (gl_FragCoord.xy * 2.0 - u_resolution)/max(u_resolution.x, u_resolution.y);
    
    float color = 0.01 / length( vec2( pos.y, sin(pos.y*10.0 - u_time*2.0)*0.3 )*pos.x);
    
    float blue = color * 10.0 * abs(sin(u_time/2.0));
    
    gl_FragColor = vec4(0.5 + color, color, blue, 0.0) * SKDefaultShading();
}
