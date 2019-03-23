precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
uniform sampler2D u_texture_0; 

vec2 N22( vec2 p)
{
    vec3 a = fract(p.xyx*vec3(123.34, 234.34, 345.65));
    a += dot(a,a+34.45); 
    return fract(vec2(a.x*a.y, a.y*a.z));
}

vec3 hue2rgb(float hue) {
    return clamp( 
        abs(mod(hue * 6.0 + vec3(0.0, 4.0, 2.0), 6.0) - 3.0) - 1.0, 
        0.0, 1.0);
}

void main() {

    vec2 tuv = gl_FragCoord.xy/u_resolution.xy;
    vec2 uv = (2.*gl_FragCoord.xy-u_resolution.xy)/u_resolution.y;

    // vec4 colorT = texture2D(u_texture_0, uv);
    // gl_FragColor = vec4(vec3(colorT.r,colorT.g, colorT.b ), 1.0);

    float m = 0.0;
    float t = 100.+u_time/4.0;

    for( int i =0; i < 20; i++)
    {
        vec2 n = N22(vec2(i));
        vec2 p  = sin(n*t);

        //n = (n+vec2(1.0))/2.0;

        float d = length(uv-p);
        //m += smoothstep(n.x, 0.001, d);
        // first param shoudl be a parameter or vary over time
        m += smoothstep(0.6, 0.001, d);
    }
    //m = clamp(m, 0.0, 1.0);

    //m = smoothstep(0.4,0.41, m);
    
    // multiplier should be a param or vary over time
    m = sin(m*8.0); // from -1 to 1
    m = (m+1.0)*0.5; // back from 0 to 1
    
    //vec4 finalColor = vec4(vec3(m), 1.0);

    vec4 colorT = texture2D(u_texture_0, vec2(m, 10.));
    vec4 finalColor = vec4( colorT.r, colorT.g, colorT.b, 1.0 );

    gl_FragColor = finalColor;
}