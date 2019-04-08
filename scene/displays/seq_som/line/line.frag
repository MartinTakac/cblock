layout (location=0) out vec4 bl_frag_colour;
uniform float shader_data[7];
void main(void)
{
	vec4 frag_colour=vec4(0.212,0.540,0.540,1.0);

	bl_frag_colour=frag_colour;
    bl_frag_colour[3] *= shader_data[6];
}
