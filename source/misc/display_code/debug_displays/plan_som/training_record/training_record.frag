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


vec4 frag_colour = vec4(0.0,0.0,0.0,1.0);
frag_colour.r=1.-Itex.r;
frag_colour.g=1.-Itex.g;
frag_colour.b=1.-Itex.b;

#if __VERSION__ < 130
	gl_FragColor=frag_colour;
#else
	bl_frag_colour=frag_colour;
#endif
}
