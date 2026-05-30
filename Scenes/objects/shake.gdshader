shader_type canvas_item;

uniform float shake_intensity = 0.0;//Shake intensity
uniform float shake_speed = 20.0;//Shake speed

void vertex() {
	vec2 shake = vec2(0.0); // shake
	if(VERTEX.y < 0.0){
		shake.x = sin(TIME * shake_speed + VERTEX.y) * shake_intensity;
	}
	VERTEX.xy += shake;
}

void fragment() {
	// Called for every pixel the material is visible on.
}
