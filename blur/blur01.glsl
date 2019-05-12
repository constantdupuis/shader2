
/*
 Blur

 En samplent la texture en cercle autour de l'uv de référence.
 Le diametre du ercle de sampling peut change, l'angle de départ,
 l'incrément de l'angle
*/

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
    float a = tuv.x; // start angle
    //a = fract(tuv.x*6543.876); // start angle
    for(float s = 0.0; s < 16.0; s++)
    {
      // sample around a cercle
      vec2 offs = vec2(sin(a) ,cos(a)) * 0.02 * blurIntensity;

      // bring sample inside cercle
      //offs *= fract(a*tuv.x*blurIntensity*479944.8975);
      //offs *= fract(sin(s+1.*a*12734.4479)*479944.8975);
      //offs = sqrt(offs);
      color += texture2D(u_texture_0, tuv+offs);
      a+= (TWO_PI / numberSample) / tuv.y; // increment par quartier
      //a++; // increment par unité de radian
    }
    color /= 16.0; // 

    gl_FragColor = color;
}