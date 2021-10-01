void main(){
  vec2 coord = (gl_FragCoord.xy * 2.0 - u_resolution) / min(u_resolution.x, u_resolution.y);
  coord.x += sin(u_time) + cos(u_time * 1.1);
  coord.y += cos(u_time) + sin(u_time * 0.6);
  float color = 0.0;

  color += 0.1 * (abs(sin(u_time)) + 0.4) / length(coord);

  gl_FragColor = vec4(vec3(color), 0.0) * SKDefaultShading();
}
