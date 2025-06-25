shader_type canvas_item;

uniform sampler2D noise_tex;

uniform float knobStrength = 3.0;
uniform float pixelsPerPlank = 100.0;
uniform float linesPerPlank = 5.5;
uniform float verticalScale = 8.0;
uniform float lineStrength = 0.8;
uniform float plankLength = 12.0;

float rand(vec2 n) {
    return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float noise(vec2 p){
    vec2 ip = floor(p);
    vec2 u = fract(p);
    u = u * u * (3.0 - 2.0 * u);
    float res = mix(
        mix(rand(ip), rand(ip + vec2(1.0, 0.0)), u.x),
        mix(rand(ip + vec2(0.0, 1.0)), rand(ip + vec2(1.0, 1.0)), u.x),
        u.y
    );
    return res;
}

float noisetex(vec2 x) {
    // assuming 256x256 noise texture
    vec2 coord = (floor(x) + fract(x) + 0.5) / 256.0;
    return texture(noise_tex, coord).r;
}

float height(vec2 a) {
    a *= vec2(1.0, 1.0 / verticalScale);
    return linesPerPlank * (knobStrength * noise(a) + a.x);
}

vec2 grad(vec2 x) {
    vec2 h = vec2(0.05, 0.0);
    return vec2(
        height(x + h.xy) - height(x - h.xy),
        height(x + h.yx) - height(x - h.yx)
    ) / (2.0 * h.x);
}

vec4 composit(vec4 top, vec4 bottom) {
    return vec4(mix(top.rgb, bottom.rgb, 1.0 - top.a), 1.0);
}

void fragment() {
    vec2 fragCoord = UV * pixelsPerPlank;
    vec2 pixel = fragCoord / pixelsPerPlank;
    
    float plank = floor(pixel.x);
    float start = 15.0 * rand(vec2(plank));
    float item = floor(pixel.y / plankLength + start);
    
    vec3 woodLine = vec3(90.0, 45.0, 18.0) / 255.0;
    vec2 plankPixel = pixel + vec2(124.0, 11.0) * plank;
    
    float value = height(plankPixel + item);
    vec2 gradient = grad(plankPixel + item);
    float linePos = 1.0 - smoothstep(0.0, 0.08, fract(value) / length(gradient));
    float line = floor(value);
    float lineWeight = mix(1.0, 0.4 + rand(vec2(line, plank)), 0.8);
    float lineGrain = smoothstep(-0.2, 0.9, noisetex(fragCoord));
    
    vec3 woodBase = vec3(144.0, 91.0, 49.0) / 255.0;
    float darkness = mix(1.0, 0.5 + rand(vec2(plank, item)), 0.2);
    float grain = mix(1.0, 0.5 + 0.7 * noisetex(fragCoord + 12.5), 0.1);
    
    float plankGapY = step(0.0, fract(pixel.x)) * (1.0 - step(0.02, fract(pixel.x)));
    float plankGapX = step(0.0, fract(pixel.y / plankLength + start)) * (1.0 - step(0.02 / plankLength, fract(pixel.y / plankLength + start)));

    vec4 planks = vec4(vec3(0.1), max(plankGapY, plankGapX));
    vec4 lines = vec4(woodLine, lineStrength * lineWeight * lineGrain * linePos);
    vec4 wood = vec4(woodBase * darkness * grain, 1.0);
    
    COLOR = composit(planks, composit(lines, wood));
}