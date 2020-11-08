uniform sampler2D shader_texture_0;

#if __VERSION__ < 130
varying vec2 texture_coordinate;
#else
in vec2 texture_coordinate;
layout (location=0) out vec4 bl_frag_colour;
#endif

void main (void)
{
#if __VERSION__ < 130
	gl_FragColor=texture2D(shader_texture_0,texture_coordinate);
#else
	bl_frag_colour=texture(shader_texture_0,texture_coordinate);
#endif
}