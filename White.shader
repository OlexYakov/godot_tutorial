shader_type canvas_item;
uniform bool active = false;

void fragment(){
	vec4 color = texture(TEXTURE,UV);
	if (active)
		color.rgb = vec3(1,1,1);
	COLOR =  color;
}