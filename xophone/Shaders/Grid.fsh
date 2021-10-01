void main(){
  vec2 coord = gl_FragCoord.xy * 1.0 - u_resolution;
  vec3 color = vec3(0.0);

  color += abs(cos(coord.x / 180.0) + sin(coord.y / 180.0) - cos(u_time));

  gl_FragColor = vec4(color, 0.0) * SKDefaultShading();
}
