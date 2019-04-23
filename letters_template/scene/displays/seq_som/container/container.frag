layout (location=0) out vec4 bl_frag_colour;
uniform float shader_data[5];
void main(void)
{
	vec4 frag_colour=vec4(0.5,0.0,1.0,0.5);

	bl_frag_colour=frag_colour;
    bl_frag_colour[3] *= shader_data[4];
}
