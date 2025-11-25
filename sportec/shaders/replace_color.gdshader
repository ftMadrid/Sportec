shader_type canvas_item;

group_uniforms Palettes;
uniform sampler2D skin_palette : filter_nearest;
uniform sampler2D team_palette : filter_nearest;
group_uniforms;

uniform int skin_color;
uniform int team_color;

vec2 px_to_uv(ivec2 pos, ivec2 tex_size){
	return vec2(
		(float(pos.x) + 0.5) / float(tex_size.x),
		(float(pos.y) + 0.5) / float(tex_size.y)
	);
}

vec4 palette_color(vec4 color, sampler2D palette, int selection){
	ivec2 tex_size = textureSize(palette, 0);

	for(int i = 0; i < tex_size.x; i++){

		vec2 uv_color_ref = px_to_uv(ivec2(i, 0), tex_size);
		vec4 color_ref = texture(palette, uv_color_ref);

		if(distance(color, color_ref) < 0.01){
			vec2 uv_color_dest = px_to_uv(ivec2(i, selection), tex_size);
			return texture(palette, uv_color_dest);
		}
	}
	return color;
}

void fragment() {
	vec4 current_color = texture(TEXTURE, UV);

	// just for optimization
	if (current_color.a == 0.01) {
		discard;
	}

	current_color = palette_color(current_color, team_palette, team_color);
	current_color = palette_color(current_color, skin_palette, skin_color);

	COLOR = current_color;
}
