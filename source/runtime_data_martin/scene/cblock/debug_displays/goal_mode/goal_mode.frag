#if __VERSION__ < 130
varying vec2 texture_coordinate;
#else
in vec2 texture_coordinate;
layout (location=0) out vec4 bl_frag_colour;
#endif

uniform float shader_data[3];

void main (void)
{
	vec4 Itex = vec4(0,0,0,1);
    if (texture_coordinate[0]<0.33)
    {
        Itex = vec4(0,0,1,1);
        if (shader_data[0] < 0)
            Itex = vec4(1,0,0,1);
        if (shader_data[0] > 0)
            Itex = vec4(0,1,0,1);
    }
    if (texture_coordinate[0]>0.33 && texture_coordinate[0]<0.66)
    {
        Itex = vec4(0,0,1,1);
        if (shader_data[1] < 0)
            Itex = vec4(1,0,0,1);
        if (shader_data[1] > 0)
            Itex = vec4(0,1,0,1);
    }
    if (texture_coordinate[0]>0.66)
    {
        Itex = vec4(0,0,1,1);
        if (shader_data[2] < 0)
            Itex = vec4(1,0,0,1);
        if (shader_data[2] > 0)
            Itex = vec4(0,1,0,1);
    }
    
#if __VERSION__ < 130
	gl_FragColor=Itex;
#else
	bl_frag_colour=Itex;
#endif
}
