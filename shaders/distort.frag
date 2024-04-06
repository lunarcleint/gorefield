#pragma header
// https://www.shadertoy.com/view/7lBGRm

const float EPSILON = 1e-10;
uniform vec2 shake;

vec3 RGBtoHCV(vec3 rgb)
{
    vec4 p = (rgb.g < rgb.b) ? vec4(rgb.bg, -1., 2. / 3.) : vec4(rgb.gb, 0., -1. / 3.);
    vec4 q = (rgb.r < p.x) ? vec4(p.xyw, rgb.r) : vec4(rgb.r, p.yzx);
    float c = q.x - min(q.w, q.y);
    float h = abs((q.w - q.y) / (6. * c + EPSILON) + q.z);
    return vec3(h, c, q.x);
}

void main()
{
    vec2 uv = openfl_TextureCoordv;

    vec4 col = vec4(flixel_texture2D(bitmap, uv));
    if (shake.x == 0.0 && shake.y == 0.0) {
        gl_FragColor = col;
        return;
    }
    
    float h = RGBtoHCV(col.rgb).z;
    vec3 col2 = flixel_texture2D(bitmap, vec2(uv.x+h*shake.x, uv.y+(1.0-h)*shake.y)).rgb;

    gl_FragColor = vec4(col2,1.0);
}