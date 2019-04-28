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

    vec3 color1 = vec3(.5,.5,.5);
    vec3 color2 = vec3(.5,.5,.5);

    vec3 color = color1 + color2;

    gl_FragColor = vec4(color, 1.0);

}