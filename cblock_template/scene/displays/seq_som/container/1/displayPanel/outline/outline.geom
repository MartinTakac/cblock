layout(lines) in;
layout(line_strip,max_vertices=5) out;

uniform mat4 bl_model_view_projection_matrix;

uniform float shader_data[5];

void main(void)
{	
    float offsetx = shader_data[0];
    float offsety = shader_data[1];
    float scalex = 1.0+shader_data[2];
    float scaley = 1.0+shader_data[3];

	vec3 start_vertex=vec3(-1.073*scalex+offsetx,1.076*scaley+offsety,0.0);
	vec3 A=vec3(1.069*scalex+offsetx,1.076*scaley+offsety,0.0);
    vec3 B=vec3(1.069*scalex+offsetx,-1.066*scaley+offsety,0.0);
    vec3 C=vec3(-1.073*scalex+offsetx,-1.066*scaley+offsety,0.0);
    vec3 end_vertex=vec3(-1.073*scalex+offsetx,1.076*scaley+offsety,0.0);
    
    gl_Position=bl_model_view_projection_matrix*vec4(start_vertex,1);
    EmitVertex();
    gl_Position=bl_model_view_projection_matrix*vec4(A,1);
    EmitVertex();
	gl_Position=bl_model_view_projection_matrix*vec4(B,1);
	EmitVertex();
    gl_Position=bl_model_view_projection_matrix*vec4(C,1);
    EmitVertex();
	gl_Position=bl_model_view_projection_matrix*vec4(end_vertex,1);
	EmitVertex();
	EndPrimitive();
}
