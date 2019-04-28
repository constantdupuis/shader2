/* Main function, uniforms & utils */
#ifdef GL_ES
    precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

uniform float u_mPower;

uniform sampler2D u_texture_0; 
uniform sampler2D u_texture_1;

#define PI_TWO			1.570796326794897
#define PI				3.141592653589793
#define TWO_PI			6.283185307179586

void main() {
    vec2 uv = gl_FragCoord.xy/u_resolution;
    uv = (uv-0.5)*2.0;
    uv.x *= u_resolution.x/u_resolution.y;

    vec2 mx = u_mouse/u_resolution;
    mx = (mx-0.5)*2.0;
    mx.x *= u_resolution.x/u_resolution.y;

    vec3 color = vec3(
        uv.x, 
        0.0, 
        0.0
    );

    float d = distance(uv, vec2(0.0));
    d = smoothstep(0.5, 0.0, d);
    color = vec3(d);

    float md = distance(uv, mx);
    md = smoothstep(0.5, 0.0, md);
    color = vec3(d+md);

    

    float mm = d+md;

    mm *= 100.0*u_mPower;
    mm = sin(mm-PI_TWO);
    mm = (mm+1.0)/2.0;

    vec3 color1 = texture2D(u_texture_0, vec2(mm,0.5)).rgb;
    vec3 color2 = texture2D(u_texture_1, vec2(mm,0.5)).rgb;

    // color1 *= smoothstep(0.0,0.1,d);
    // color2 *= smoothstep(0.0,0.1,md);

    color1 *= d;
    color2 *= md;
    
    //color = vec3(mm);
    color = color1+color2+(vec3(1.0)* (1.0-(d+md)));

    gl_FragColor = vec4(color, 1.0);
}

