#pragma header

//	 CHROMATIC ABBERATION https://www.shadertoy.com/view/wsdBWM
//	 by Tech_ (ported by lunar) 

uniform float distortion;

vec2 PincushionDistortion(vec2 uv, float strength) 
{
	vec2 st = uv - vec2(0.5, 0.5);
    float uvA = atan(st.x, st.y);
    float uvD = dot(st, st);
    return vec2(0.5, 0.5) + vec2(sin(uvA), cos(uvA)) * sqrt(uvD) * (1.0 - strength * uvD);
}

vec4 ChromaticAbberation(sampler2D tex, vec2 uv) 
{
    vec4 retColor = vec4(flixel_texture2D(tex, PincushionDistortion(uv, 0.3 * distortion)));
    return retColor;
}

void main()
{
    gl_FragColor = ChromaticAbberation(bitmap, openfl_TextureCoordv.xy);
}