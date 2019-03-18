precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
uniform float u_strength;



void main() {
    vec2 st = gl_FragCoord.xy / u_resolution.xy;
    st.x *= u_resolution.x / u_resolution.y;

    float s = sin(u_time);
    vec3 color = vec3(0.0);
    float r = fract( sin(st.x *100.+st.y*6574.)*(5647.*u_strength));
    color = vec3(r);

    gl_FragColor = vec4(color, 1.0);
}