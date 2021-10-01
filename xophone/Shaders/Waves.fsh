void main(){
  vec2 coord = (gl_FragCoord.xy / u_resolution);
  float color = 0.0;

  color += sin(coord.x * 6.0 + sin(u_time + coord.y * 90.0 + cos(coord.x * 30.0 + u_time * 2.0))) * 0.5;

  gl_FragColor = vec4(vec3(color + coord.x, color + coord.x, color), 0.0) * SKDefaultShading();
}
