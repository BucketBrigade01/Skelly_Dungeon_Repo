
shader_type canvas_item;

// Shader parameters that can be adjusted in the editor
uniform vec4 water_color : source_color = vec4(0.0, 0.4, 0.8, 1.0); // Base blue color
uniform vec4 foam_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); // White foam color
uniform float wave_speed = 1.0; // Speed of the wave animation
uniform float foam_threshold = 0.65; // Threshold for foam generation (higher = less foam)
uniform vec2 resolution = vec2(256.0, 224.0); // Match your specified resolution

// Noise texture uniform
uniform sampler2D noise_texture : repeat_enable;

void fragment() {
    // Create pixelated coordinates for the retro look
    vec2 pixel_size = 1.0 / resolution;
    vec2 pixelated_uv = floor(UV / pixel_size) * pixel_size;
    
    // Time-based animation for texture sampling
    float time = TIME * wave_speed;
    
    // Sample noise texture at different scales and offsets
    vec2 noise_uv1 = pixelated_uv * 10.0 + vec2(time * 0.5, time * 0.3);
    vec2 noise_uv2 = pixelated_uv * 15.0 + vec2(-time * 0.4, time * 0.2);
    
    // Sample the noise texture
    float noise1 = texture(noise_texture, noise_uv1).r;
    float noise2 = texture(noise_texture, noise_uv2).r;
    
    // Combine noise patterns
    float combined_noise = (noise1 + noise2) * 0.5;
    
    // Create foam pattern based on noise threshold
    float foam = step(foam_threshold, combined_noise);
    
    // Final color combines the water color with foam
    COLOR = mix(water_color, foam_color, foam);
}