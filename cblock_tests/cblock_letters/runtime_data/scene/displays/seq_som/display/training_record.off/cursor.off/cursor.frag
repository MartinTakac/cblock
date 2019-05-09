uniform sampler2D shader_texture_0;

#if __VERSION__ < 130
varying vec2 texture_coordinate;
#else
in vec2 texture_coordinate;
layout (location=0) out vec4 bl_frag_colour;
#endif

void main (void)
{
	vec4 Itex;

#if __VERSION__ < 130
	Itex=texture2D(shader_texture_0,texture_coordinate);
#else
	Itex=texture(shader_texture_0,texture_coordinate);
#endif
Itex=vec4(1.,0.,0.,0.85);
#if __VERSION__ < 130
	gl_FragColor=Itex;
    gl_FragColor[3]=0.5;
#else
	bl_frag_colour=Itex;
    bl_frag_colour[3]=0.5;
#endif
}
