//
//void main( void ) {
//
//    vec2 position = ( gl_FragCoord.xy / u_resolution.xy ) ;
//
//    float color = 0.0;
//    color += sin( position.x * cos( u_time / 15.0 ) * 80.0 ) + cos( position.y * cos( u_time / 15.0 ) * 10.0 );
//    color += sin( position.y * sin( u_time / 10.0 ) * 40.0 ) + cos( position.x * sin( u_time / 25.0 ) * 40.0 );
//    color += sin( position.x * sin( u_time / 5.0 ) * 10.0 ) + sin( position.y * sin( u_time / 35.0 ) * 80.0 );
//    color *= sin( u_time / 10.0 ) * 0.5;
//
//    gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + u_time / 3.0 ) * 0.75 ), 0.0 ) * SKDefaultShading();
//
//}

