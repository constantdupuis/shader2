/* Main function, uniforms & utils */
#ifdef GL_ES
    precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

uniform sampler2D u_texture_0;

#define PI_TWO			1.570796326794897
#define PI				3.141592653589793
#define TWO_PI			6.283185307179586

vec2 N22(vec2 p)
{
    vec3 a = fract(p.xyx*vec3(123.34, 234.34, 345.65));
    //vec3 a = fract(p.xyx*vec3(632.34, 234.34, 345.65));
    //vec3 a = fract(p.xyx*vec3(632.34, 234.34, 44.65));
    a+= dot(a, a+34.45);
    return fract(vec2(a.x*a.y, a.y*a.z));
}

vec3 hsv2rgb(vec3 c) {
  vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
  vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
  return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main() {
    vec2 uv = gl_FragCoord.xy/u_resolution.xy;
    vec2 uvb = uv;
    uv -= 0.5;
    uv *= 2.0;
    float ratio = u_resolution.x/u_resolution.y;
    uv.x *= ratio;

    float speed = .2;

    float t = 100.+u_time*speed;

    float minDist = 100.;
    float cellIndex = 0.;

    float numberOfCells = 50.;

    vec3 coloruv;

    for( float i = 0.; i<50.; i++)
    {
        vec2 n = N22(vec2(i+10.));
        n.x *= ratio;
        vec2 p = sin(n*t);

        float d = length(uv-p);
        
        //d = smoothstep(0.1, 0.41, d); // to change contrast
        //d *= 4.0; // like graine de grenadine
        //d = d*d; // intestin ? sir alpha à 0.
        //m += 1. - smoothstep(0.01, 0.02, d);

        if( d<minDist)
        {
            minDist = d;
            cellIndex = i/numberOfCells;
            //coloruv =hsv2rgb(vec3(cellIndex, 0.1, 0.5))*(1.-d);
            coloruv = vec3(d);
        }
    }

    vec4 color = vec4(coloruv, 1.0);

    //vec4 colorT1 = texture2D(u_texture_0, vec2(cellIndex, 0.5));
    //vec3 color = vec3(minDist);
    //vec3 color = colorT1;
    //vec3 color = vec3(uv.x, uv.y, 0.);

    gl_FragColor = color;
}