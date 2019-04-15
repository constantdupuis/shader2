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
    
    // convert coord from pixel coordinate to 0 to 1
    vec2 uv = gl_FragCoord.xy / u_resolution.xy;
    uv.x *= u_resolution.x / u_resolution.y; // fix screen aspect ratio 
    uv -= vec2((u_resolution.x / u_resolution.y)/2.0, 0.5); // center (0,0)

    // create polar coordinats
    // s rotate around centre 0 to 1
    // t got from center to edges 0 to 1  
    float s = (atan(uv.x, uv.y)/TWO_PI+.5);
    float t = length(uv);

    //t += u_time/10.;
    float s2 = s + t*2.;
    s += t * - sin(u_time/10.)*1.;
    
    vec3 color = texture2D(u_texture_0, vec2(s, t)).rgb; 
    vec3 color2 = texture2D(u_texture_0, vec2(s2, t)).rgb;

    color *= color2*2.;

    gl_FragColor = vec4(color, 1.0);
}