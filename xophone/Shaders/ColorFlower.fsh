//void main(){
//    vec2 uv = (gl_FragCoord.xy - .5 * u_resolution.xy) / u_resolution.y;
//
//    for(float i=1.; i<9.; i++){
//        uv.x += .5/i*sin(1.9 * i * uv.y + u_time / 2. - cos(u_time / 66. + uv.x))+21.;
//        uv.y += .4/i*cos(1.6 * i * uv.x + u_time / 3. + sin(u_time / 55. + uv.y))+31.;
//    }
//
//    gl_FragColor = vec4(sin(3. * uv.x - uv.y), sin(3. * uv.y), sin(3. * uv.x), 0) * SKDefaultShading();
//}

float distanceFunction(vec2 pos, float time) {
    float a = atan(pos.x/pos.y);
    float f = 10.;
    float squiggle = sin( time+pos.x*16.0+f * a) *0.14;
    squiggle*=sin(time*2.37+a*8.0)*3.5;
    return length(pos) - .05 - squiggle*squiggle;
}

void main() {
    vec2 p = (gl_FragCoord.xy * 2.0 - u_resolution) / min(u_resolution.x, u_resolution.y);

    p.x = dot(p,p);
    
    vec3 col = vec3(0.1,0.24,.5) * distanceFunction(p, u_time);
    col = smoothstep(0.01, 0.31, col);

    col = vec3(1.0)-col;

    gl_FragColor = vec4(col, 0.0) * SKDefaultShading();
}
