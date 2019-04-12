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


void main() {

    vec2 uv = gl_FragCoord.xy / u_resolution.xy;
    uv -= 0.5;
    
    float s = (atan(uv.x, uv.y)/TWO_PI+.5);
    float t = length(uv);

    s += u_time/6.+t*sin(u_time);
    s *=8.;

    t*=6.;

    vec2 st = vec2(s, t);

    float x = (sin(st.x*10.)+1.0)/2.0;
    float y = cos(st.x*15.);

    vec2 q = fract(st);

    vec3 color = vec3(q.x, q.y, 0.0);
    //color = texture2D(u_texture_0, st).rgb;

    gl_FragColor = vec4(color, 1.0);
}