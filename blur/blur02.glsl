/* Main function, uniforms & utils */
#ifdef GL_ES
    precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

uniform sampler2D u_texture_0; 
uniform float blurIntensity;

#define PI_TWO			1.570796326794897
#define PI				  3.141592653589793
#define TWO_PI			6.283185307179586



void main() {
    vec2 tuv = gl_FragCoord.xy/u_resolution.xy;

    vec4 color;

    float t = u_time;

    float numberSample = 16.0;
    float a = tuv.x;
    //a = fract(tuv.x*6543.876);
    for(float s = 0.0; s < 16.0; s++)
    {
      vec2 offs = vec2(sin(a) ,cos(a)) * 0.02 * blurIntensity;
      //offs *= fract(a*tuv.x*blurIntensity*479944.8975);
      //offs *= fract(sin(s+1.*a*12734.4479)*479944.8975);
      //offs = sqrt(offs);
      color += texture2D(u_texture_0, tuv+offs);
      a+= (TWO_PI / numberSample) / tuv.y;
      //a++;
    }

    color /= 16.0;

    gl_FragColor = color;
}