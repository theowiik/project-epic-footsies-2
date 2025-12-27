shader_type spatial;
render_mode unshaded, fog_disabled;

uniform sampler2D screen_texture : hint_screen_texture;
uniform sampler2D depth_texture : hint_depth_texture;
uniform sampler2D normal_texture : hint_normal_roughness_texture;

uniform float pixel_size : hint_range(1.0, 32.0, 1.0) = 4.0;
uniform float color_levels : hint_range(2.0, 16.0, 1.0) = 4.0;
uniform float edge_strength : hint_range(0.0, 5.0, 0.1) = 1.0;
uniform vec3 edge_color : source_color = vec3(0.0);
uniform sampler2D ramp : source_color, repeat_disable;

void vertex() {
    POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

float get_depth(vec2 uv) {
    float d = texture(depth_texture, uv).r;
    return d;
}

vec3 get_normal(vec2 uv) {
    return texture(normal_texture, uv).rgb * 2.0 - 1.0;
}

float detect_edge(vec2 uv, vec2 texel) {
    // Sobel edge detection on depth
    float d = get_depth(uv);
    float d_left = get_depth(uv - vec2(texel.x, 0.0));
    float d_right = get_depth(uv + vec2(texel.x, 0.0));
    float d_up = get_depth(uv - vec2(0.0, texel.y));
    float d_down = get_depth(uv + vec2(0.0, texel.y));
    
    float depth_edge = abs(d_left - d_right) + abs(d_up - d_down);
    
    // Edge detection on normals
    vec3 n = get_normal(uv);
    vec3 n_left = get_normal(uv - vec2(texel.x, 0.0));
    vec3 n_right = get_normal(uv + vec2(texel.x, 0.0));
    vec3 n_up = get_normal(uv - vec2(0.0, texel.y));
    vec3 n_down = get_normal(uv + vec2(0.0, texel.y));
    
    float normal_edge = length(n_left - n_right) + length(n_up - n_down);
    
    return clamp(depth_edge * 50.0 + normal_edge * 2.0, 0.0, 1.0);
}

void fragment() {
    vec2 tex_size = vec2(textureSize(screen_texture, 0));
    vec2 texel = 1.0 / tex_size;
    
    // Pixelation
    vec2 pixel_count = tex_size / pixel_size;
    vec2 pixelated_uv = floor(SCREEN_UV * pixel_count) / pixel_count;
    
    vec4 color = texture(screen_texture, pixelated_uv);
    
    // Posterize colors
    vec3 posterized = floor(color.rgb * color_levels + 0.5) / color_levels;
    
    // Optional: use ramp based on luminance
    float lum = dot(posterized, vec3(0.299, 0.587, 0.114));
    vec3 ramp_value = texture(ramp, vec2(lum, 0.5)).rgb;
    
    // Blend original hue with ramp brightness
    vec3 toon_color = posterized * (ramp_value * 0.5 + 0.5);
    
    // Edge detection
    float edge = detect_edge(SCREEN_UV, texel * pixel_size) * edge_strength;
    
    // Final mix
    ALBEDO = mix(toon_color, edge_color, clamp(edge, 0.0, 1.0));
}