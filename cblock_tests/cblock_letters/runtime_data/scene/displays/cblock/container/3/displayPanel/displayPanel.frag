uniform sampler2D shader_texture_0;

#if __VERSION__ < 130
varying vec2 texture_coordinate;
#else
in vec2 texture_coordinate;
layout (location=0) out vec4 bl_frag_colour;
#endif
uniform float shader_data[3];

void main (void)
{
#if __VERSION__ < 130
	gl_FragColor=texture2D(shader_texture_0,texture_coordinate);
    gl_FragColor[3]=0.7;
    gl_FragColor[3] *= shader_data[2];
#else
	bl_frag_colour=texture(shader_texture_0,texture_coordinate);
    bl_frag_colour[3]=0.7;
    bl_frag_colour[3] *= shader_data[2];
#endif
}
