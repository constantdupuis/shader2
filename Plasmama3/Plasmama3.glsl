precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
uniform sampler2D u_texture_0; 
uniform sampler2D u_texture_1;
uniform sampler2D u_texture_2;
uniform float u_strength;
uniform float u_strength2;

// pseudo random generator
vec2 N22( vec2 p)
{
    vec3 a = fract(p.xyx*vec3(123.34, 234.34, 345.65));
    a += dot(a,a+34.45); 
    return fract(vec2(a.x*a.y, a.y*a.z));
}

// HUE To RGB convertion
vec3 hue2rgb(float hue) {
    return clamp( 
        abs(mod(hue * 6.0 + vec3(0.0, 4.0, 2.0), 6.0) - 3.0) - 1.0, 
        0.0, 1.0);
}

void main() {

    // pixel uv, range -1 to 1 and compensate screen aspect ratio
    vec2 uv = (2.*gl_FragCoord.xy-u_resolution.xy)/u_resolution.y; 

    vec2 uv2 = uv; 
    uv2.x *= -1.0;
    
    vec2 uv3 = uv; 
    uv3.y *= -1.0;

    float m = 0.0; // gradiant accumulator
    float m2 = 0.0; // gradiant accumulator 2
    float m3 = 0.0; // gradiant accumulator 3

    float t = 100.+u_time/(20.0); // time base

    // create "particles"
    for( int i = 0; i < 20; i++)
    {
        // pick random position, same input given same output
        vec2 n = N22(vec2(i));
        // move from initial random pos
        vec2 p  = sin(n*t);

        // distance from particle centre tu uv
        // give a gradiant range from 0 to > 1
        float d = length(uv-p);
        float d2 = length(uv2-p);
        float d3 = length(uv3-p);

        // limit gradiant from 0 to 1 and add it to  m
        m += smoothstep(0.6, 0.001, d);
        m2 += smoothstep(0.6, 0.001, d2);
        m3 += smoothstep(0.6, 0.001, d3);
    }
    // m range from 0 to > 1
    m = sin(m*3.0); // get gradiant back in -1, 1 range
    m = (m+1.0)*0.5; // get grdiant in 0, 1 range
    
    m2 = sin(m2*10.0);
    m2 = (m2+1.0)*0.5;
    
    m3 = sin(m3*10.0);
    m3 = (m3+1.0)*0.5;

    // use gradiant to pick texture color
    vec4 colorT =  texture2D(u_texture_0, vec2(m,  10.));
    vec4 colorT2 = texture2D(u_texture_1, vec2(m2, 10.));
    vec4 colorT3 = texture2D(u_texture_2, vec2(m3, 10.));

    vec4 finalColor = colorT+(colorT2*(1.0-colorT.a))+(colorT3*(1.0-colorT2.a+1.0-colorT.a));
    //vec4 finalColor = colorT+(colorT2*(1.0-colorT.a));
    //vec4 finalColor = vec4(uv.x, 0.0,0.0,1.0);

    gl_FragColor = finalColor;
}