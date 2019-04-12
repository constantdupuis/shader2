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
    
    // create polar coordinats
    // s rotate around centre 0 to 1
    // t got from center to edges 0 to 1  
    float s = (atan(uv.x, uv.y)/TWO_PI+.5);
    float t = length(uv);

    // animate polar coodinates (pc)
    s += u_time/16.+t*sin(u_time/2.);
    s *= 8.;
    t *= 6.;

    // make them vec2
    vec2 st = vec2(s, t);

    // create grid from pc
    vec2 q = fract(st);

    // move cell centre, -0.5 to 0.5
    q-= 0.5;

    // calulate distance from centre of cell
    float d = length(q-vec2(0.));

    //d*=d;

    vec3 color = vec3(q.x, q.y, d);
    color = vec3(d);
    color = texture2D(u_texture_0, vec2(d, 0.5)).rgb;

    gl_FragColor = vec4(color, 1.0);
}