uniform sampler2D shader_texture_0;
uniform sampler2D shader_texture_1;
uniform sampler2D shader_texture_2;

#if __VERSION__ < 130
varying vec2 texture_coordinate;
#else
in vec2 texture_coordinate;
layout (location=0) out vec4 bl_frag_colour;
#endif

uniform float shader_data[3];
vec4 outColour = vec4(0.0,0.0,0.0,0.0);
vec4 outColour2 = vec4(0.0,0.0,0.0,0.0);

void main (void)
{
//#define GRID
#ifdef GRID   
    if (mod(floor(texture_coordinate[0]*100),5)==0)
        discard;
    if (mod(floor(texture_coordinate[1]*100),5)==0)
        discard;
#endif
    
#if __VERSION__ < 130
	outColour=texture2D(shader_texture_0,texture_coordinate);
    outColour2=texture2D(shader_texture_2,texture_coordinate);
#else
	outColour=texture(shader_texture_0,texture_coordinate);
    outColour2=texture(shader_texture_2,texture_coordinate);
#endif
	if (shader_data[0]>0.1)
	{
		if (texture_coordinate[0]<0.1)
			outColour = vec4(0.0,1.0,1.0,1.0);
	}
    if (shader_data[1]>0.1)
    {
        if (texture_coordinate[1]<0.1)
            outColour = vec4(0.0,1.0,0.0,1.0);
    }
#define PATTERN
#ifdef PATTERN
    vec2 texture_coordinate_pattern;
    texture_coordinate_pattern[0]=50.0*texture_coordinate[0]-floor(50.0*texture_coordinate[0]);
    texture_coordinate_pattern[1]=50.0*texture_coordinate[1]-floor(50.0*texture_coordinate[1]);

#if __VERSION__ < 130
    float background=texture2D(shader_texture_1,texture_coordinate_pattern).r;
#else
    float background=texture(shader_texture_1,texture_coordinate_pattern).r;
#endif
    outColour.a=background;
    outColour2.a=background;
#endif //PATTERN
    
    // White if activated, otherwise cyan
    
    outColour.r=outColour2.r;
    
    outColour.r=0.1-outColour.r;
    outColour.g=0.5*outColour.g;
    outColour.b=outColour.b;
    
#if __VERSION__ < 130
	gl_FragColor=outColour;
#else
	
    bl_frag_colour=outColour;
    bl_frag_colour[3] *= shader_data[2];
#endif
}
