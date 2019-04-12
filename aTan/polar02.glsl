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
    
    // Create polar coordinates in 0-1 range
    float s = (atan(uv.x, uv.y)/TWO_PI+.5);
    float t = length(uv);

    // scale or animate polar coordinates
    s += -u_time/4.;
    s += t; 
    vec2 st = vec2(s, t);

    // use polar coordinates to create shape

    vec2 q = st;

    q.x *= TWO_PI * 5.;
    //q.y += sin(q.x);

    float v = (sin(q.x)+2.)/10.;
    float c  = smoothstep(0.11+v, 0.05, q.y);
    //c *= 1.-smoothstep(0.12, 0.13, q.y);

    //c = q.y;

    vec3 color = vec3(c, c/2., 0.0);
    
    gl_FragColor = vec4(color, 1.0);
}