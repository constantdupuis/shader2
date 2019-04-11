// Author: Luca Zampetti
// Title: vscode-glsl-canvas Buffers examples

uniform sampler2D u_buffer0;

/* Main function, uniforms & utils */
#ifdef GL_ES
    precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

#define PI_TWO			1.570796326794897
#define PI				3.141592653589793
#define TWO_PI			6.283185307179586

uniform sampler2D u_texture_0; 
uniform sampler2D u_texture_1; 

vec2 N22( vec2 p)
{
    vec3 a = fract(p.xyx*vec3(123.34, 234.34, 345.65));
    a += dot(a,a+34.45); 
    return fract(vec2(a.x*a.y, a.y*a.z));
}


#if defined(BUFFER_0)

void main() 
{   
    vec2 uv = (2.*gl_FragCoord.xy-u_resolution.xy)/u_resolution.y;

    float m = 0.0;
    float t = 100.+u_time/(20.0);

    for( int i =0; i < 20; i++)
    {
        vec2 n = N22(vec2(i));
        vec2 p  = sin(n*t);

        float d = length(uv-p);
        
        m += smoothstep(0.6, 0.001, d);
    }
    m = sin(m*6.0);
    m = (m+1.0)*0.5;
    
    vec4 colorT = texture2D(u_texture_0, vec2(m, 10.));
    vec4 finalColor = vec4( colorT.r, colorT.g, colorT.b, 1.0 );

    gl_FragColor = finalColor;
}

#else

void main()
{
    vec2 uv = gl_FragCoord.xy/u_resolution.xy;
    
    float t = 100.+u_time/(20.0);

    // create a moving point
    vec2 pr = N22(vec2(1.5));
    t *=10.0;
    vec2 np  = (sin(pr+t)+1.)/4.;
    np+= 0.25;
    

    float swirl_radius = 0.2;
    float swirl_amount = 3.5;

    // center of swirl
    uv = uv-np;
    // distance from swirl border
    float r = length(uv);

    float d, p;
   
    if( r <= swirl_radius)
    {   
        float ratio = r/swirl_radius;
        float phi = atan(uv.y, uv.x);
        float distortion = pow( swirl_amount * ((swirl_radius - r) / swirl_radius), 2.0);
        
        d = 1.0-ratio;
        //d = ratio;

        //ratio *= ratio;

        if(swirl_amount >= 0.0)
            phi = phi + distortion;
        else
            phi = phi - distortion;

        uv.x = (uv.x*(ratio)) + ( (r*sin(phi) *(1.0-ratio) ) );
        uv.y = (uv.y*(ratio)) + ( (r*cos(phi) *(1.0-ratio) ) );
    }
    uv+=np;

    
    
    //vec3 color = vec3(d);
    vec3 color = texture2D(u_buffer0, uv).rgb;
   
    //color = vec3(d);    

    gl_FragColor = vec4(color, 1.0);
}

#endif