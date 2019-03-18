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

    //vec4 colorT = texture2D(u_texture_0, uv);
    //gl_FragColor = vec4(vec3(colorT.b), 1.0);

    float m = 0.0;
    float t = u_time/2.0;

    for( int i =0; i < 20; i++)
    {
        vec2 n = N22(vec2(i));
        vec2 p  = sin(n*t);

        n = (n+vec2(1.0))/8.0;

        float d = length(uv-p);
        m += smoothstep(n.x, 0.001, d);
    }

    m = smoothstep(0.4,0.41, m);
    
    //m = sin(m*15.);
    
    vec3 c = hue2rgb( m );
    //vec3 col = c * m;

    vec3 col = vec3(m);
    gl_FragColor = vec4(col, 1.0);
}