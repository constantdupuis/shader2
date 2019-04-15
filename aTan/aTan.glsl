/* Main function, uniforms & utils */
#ifdef GL_ES
    precision mediump float;
#endif

/* Color palette */
#define BLACK           vec3(0.0, 0.0, 0.0)
#define WHITE           vec3(1.0, 1.0, 1.0)
#define RED             vec3(1.0, 0.0, 0.0)
#define GREEN           vec3(0.0, 1.0, 0.0)
#define BLUE            vec3(0.0, 0.0, 1.0)
#define YELLOW          vec3(1.0, 1.0, 0.0)
#define CYAN            vec3(0.0, 1.0, 1.0)
#define MAGENTA         vec3(1.0, 0.0, 1.0)
#define ORANGE          vec3(1.0, 0.5, 0.0)
#define PURPLE          vec3(1.0, 0.0, 0.5)
#define LIME            vec3(0.5, 1.0, 0.0)
#define ACQUA           vec3(0.0, 1.0, 0.5)
#define VIOLET          vec3(0.5, 0.0, 1.0)
#define AZUR            vec3(0.0, 0.5, 1.0)

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

#define PI_TWO			1.570796326794897
#define PI				3.141592653589793
#define TWO_PI			6.283185307179586

uniform sampler2D u_texture_0;

vec2 N22( vec2 p)
{
    vec3 a = fract(p.xyx*vec3(123.34, 234.34, 345.65));
    a += dot(a,a+34.45); 
    return fract(vec2(a.x*a.y, a.y*a.z));
}

float plot(float uvin, float where){
  return  smoothstep( where-0.02, where, uvin) -
          smoothstep( where, where+0.02, uvin);
}

void main() {

    vec2 uv = gl_FragCoord.xy / u_resolution.xy;
    uv.x *= u_resolution.x / u_resolution.y;
    uv -= vec2((u_resolution.x / u_resolution.y)/2.0, 0.5);

    // create polar coordinats
    // s rotate around centre 0 to 1
    // t got from center to edges 0 to 1  
    float s = (atan(uv.x, uv.y)/TWO_PI+.5);
    float t = length(uv);

    float v = plot(s, fract(u_time));
    float h = plot(t, fract(u_time));

    // animate polar coodinates (pc)
    s += u_time/16.+t*sin(u_time/2.);
    s *= 8.;
    t *= 6.;

    // make them vec2
    vec2 st = vec2(s, t);

    // create grid from pc
    vec2 q = fract(st);
    vec2 i = floor(st);

    // move cell centre, -0.5 to 0.5
    q-= 0.5;

    // calulate distance from centre of cell
    vec2 c = N22(q); // kind of old drawins with points
    //vec2 c = (N22(i)-.5)/2.;
    //vec2 c = vec2(0.0);
    float d = length(q-c);
    //d*=2.0;
    //d = smoothstep(0.0, 1.0, d);

    //d*=d;

    

    vec3 color = vec3(q.x, q.y, d);
    color = vec3(d); // grey scale view of all

    color += v * LIME;
    color += h *RED;
    // map to a gradiant texture
    //color = texture2D(u_texture_0, vec2(d, 0.5)).rgb;

    gl_FragColor = vec4(color, 1.0);
}