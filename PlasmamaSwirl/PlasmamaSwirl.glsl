precision mediump float;

uniform sampler2D u_buffer0

#if defined(BUFFER_0)

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
uniform sampler2D u_texture_0; 
uniform sampler2D u_texture_1;
uniform float u_strength;
uniform float u_strength2;

vec2 N22( vec2 p)
{
    vec3 a = fract(p.xyx*vec3(123.34, 234.34, 345.65));
    a += dot(a,a+34.45); 
    return fract(vec2(a.x*a.y, a.y*a.z));
}

void main() {

    vec2 tuv = gl_FragCoord.xy/u_resolution.xy;
    vec2 uv = (2.*gl_FragCoord.xy-u_resolution.xy)/u_resolution.y;

    vec4 disp = texture2D(u_texture_1, tuv);
    vec4 dispb =  disp -  0.5;
    // gl_FragColor = vec4(vec3(colorT.r,colorT.g, colorT.b ), 1.0);
    //uv += dispb.bg*u_strength;
    ///uv += dispb.bg*(sin(u_time*(2.))/5.);

    //uv += disp.xy*(16.*u_strength);
    float m = 0.0;
    float t = 100.+u_time/(20.0);

    for( int i =0; i < 10; i++)
    {
        vec2 n = N22(vec2(i));
        vec2 p  = sin(n*t);

        //n = (n+vec2(1.0))/2.0;
        float fi = float(i)/10.0; 
        float d = length(uv-p);
        
        //m += smoothstep(n.x, 0.001, d);
        m += smoothstep(0.6, 0.001, d);
    }
    //m = clamp(m, 0.0, 1.0);

    //m = smoothstep(0.4,0.41, m);
    
    m = sin(m*6.0);
    m = (m+1.0)*0.5;
    
    //vec4 finalColor = vec4(vec3(m), 1.0);

    vec4 colorT = texture2D(u_texture_0, vec2(m, 10.));
    //colorT.rgb *= disp.bbb;
    vec4 finalColor = vec4( colorT.r, colorT.g, colorT.b, 1.0 );

    //vec4 finalColor = vec4( m, m, m, 1.0 );
    vec2 pr = N22(vec2(0.5));
    t *=10.0;
    vec2 np  = sin(pr*t);
    float nd = length(uv-np);
    nd = smoothstep(0.2,0.19,nd);

    vec4 colorT2 = texture2D(u_texture_0, vec2(nd, 10.));

    finalColor = mix( finalColor, colorT2, nd);

    gl_FragColor = finalColor;
}

#else

void main()
{
    
    vec3 color = texture2D(u_buffer0, uv).rgb;
    gl_FragColor = vec4(color, 1.0);
}

#endif