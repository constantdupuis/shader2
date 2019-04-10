// Author: Luca Zampetti
// Title: vscode-glsl-canvas Buffers examples

uniform sampler2D u_buffer0;
uniform sampler2D u_buffer1;

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

/* Coordinate and unit utils */
vec2 coord(in vec2 p) {
    p = p / u_resolution.xy;
    // correct aspect ratio
    if (u_resolution.x > u_resolution.y) {
        p.x *= u_resolution.x / u_resolution.y;
        p.x += (u_resolution.y - u_resolution.x) / u_resolution.y / 2.0;
    } else {
        p.y *= u_resolution.y / u_resolution.x;
        p.y += (u_resolution.x - u_resolution.y) / u_resolution.x / 2.0;
    }
    // centering
    p -= 0.5;
    p *= vec2(-1.0, 1.0);
    return p;
}
#define rx 1.0 / min(u_resolution.x, u_resolution.y)
#define uv gl_FragCoord.xy / u_resolution.xy
#define st coord(gl_FragCoord.xy)
#define mx coord(u_mouse)

/* Signed distance drawing methods */
float fill(in float d) { return 1.0 - smoothstep(0.0, rx * 2.0, d); }
float stroke(in float d, in float t) { return 1.0 - smoothstep(t - rx * 1.5, t + rx * 1.5, abs(d)); }
vec3 draw(in sampler2D t, in vec2 pos, in vec2 w) { vec2 s = w / 1.0; s.x *= -1.0; return texture2D(t, pos / s + 0.5).rgb; }
/* Field Adapted from https://www.shadertoy.com/view/XsyGRW */
vec3 field(float d) {
    const vec3 c1 = mix(WHITE, YELLOW, 0.4);
    const vec3 c2 = mix(WHITE, AZUR, 0.7);
    const vec3 c3 = mix(WHITE, ORANGE, 0.9);
    const vec3 c4 = BLACK;
    float d0 = abs(stroke(mod(d + 0.1, 0.2) - 0.1, 0.004));
    float d1 = abs(stroke(mod(d + 0.025, 0.05) - 0.025, 0.004));
    float d2 = abs(stroke(d, 0.004));
    float f = clamp(d * 0.85, 0.0, 1.0);
    vec3 gradient = mix(c1, c2, f);
    gradient = mix(gradient, c4, 1.0 - clamp(1.25 - d * 0.25, 0.0, 1.0));
    gradient = mix(gradient, c3, fill(d));
    gradient = mix(gradient, c4, max(d2 * 0.85, max(d0 * 0.25, d1 * 0.06125)) * clamp(1.25 - d, 0.0, 1.0));
    return gradient;
}

/* Shape 2D circle */
float sCircle(in vec2 p, in float w) {
    return length(p) * 2.0 - w;
}
float circle(in vec2 p, in float w) {
    float d = sCircle(p, w);
    return fill(d);
}
float circle(in vec2 p, in float w, float t) {
    float d = sCircle(p, w);
    return stroke(d, t);
}

// void main() {
//     vec3 color = vec3(
//         abs(cos(st.x + mx.x)), 
//         abs(sin(st.y + mx.y)), 
//         abs(sin(u_time))
//     );

//     gl_FragColor = vec4(color, 1.0);
// }




#if defined(BUFFER_0)

void main() {
    
    vec3 color = vec3(
        0.5 + cos(u_time) * 0.5,
        0.5 + sin(u_time) * 0.5,
        1.0
    );

    color =RED;
    vec3 buffer = texture2D(u_buffer1, uv, 0.0).rgb;
    buffer *= 0.99;
    vec2 p = vec2(
        st.x + cos(u_time * 5.0) * 0.3, 
        st.y + sin(u_time * 2.0) * 0.3
    );
    float c = circle(p, 0.2 + 0.1 * sin(u_time));
    buffer = mix(buffer, color, c * 1.0);
    gl_FragColor = vec4(buffer, 1.0);
}

#elif defined(BUFFER_1)

void main() {


    vec3 color = vec3(
        0.5 + cos(u_time) * 0.5,
        0.5 + sin(u_time) * 0.5,
        1.0
    );
    color = GREEN;
    vec3 buffer = texture2D(u_buffer0, uv, 0.0).rgb;
    buffer *= 0.99;
    vec2 p = vec2(
        st.x + sin(u_time * 2.0) * 0.3, 
        st.y + cos(u_time * 6.0) * 0.3
    );
    float c = circle(p, 0.2 + 0.1 * cos(u_time));
    buffer = mix(buffer, color, c * 1.0);
    gl_FragColor = vec4(buffer, 1.0);
}

#else

void main() {

    vec3 color = BLACK;
    vec3 b0 = texture2D(u_buffer0, uv).rgb;
    //vec3 b1 = texture2D(u_buffer1, uv).rgb;
    color += b0;
    //color += b1;
    gl_FragColor = vec4(color, 1.0);
}

#endif