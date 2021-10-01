
void main()
{
    
    vec2 p1 = (gl_FragCoord.xy * 2.0 - u_resolution) / min(u_resolution.x, u_resolution.y);
    vec3 destColor = vec3(0.0);
    for(float i = 0.0; i < 16.0; i++){
        float j = i + 1.5;
        vec2 q = p1 + vec2(cos(4. * j), sin(4. * j)) * 0.5;
        destColor += 0.05 / length(q);
    }
    
    
    vec2 p=(2.0*gl_FragCoord.xy-u_resolution)/max(u_resolution.x,u_resolution.y);
    
    for(float i=1.;i<10.;i++)
    {
        p.x += .5/i*sin(i*p.y+u_time)+1.;
        p.y += .5/i*cos(i*p.x+u_time)+2.;
    }
    
    p.y += cos(u_time/4.)*5.;
    p.x += sin(u_time/3.)*4.;
    
    vec3 col=vec3(abs(sin(.2*p.x))*1.3,  abs(sin(.2*p.y))+0.3, abs(sin(0.2*p.x+p.y))+0.3);
    float dist = sqrt(col.x*col.x + col.y * col.y + col.z*col.z);
    
        
        
    gl_FragColor = vec4(col/dist*destColor-0.25, 0) * SKDefaultShading();
}
