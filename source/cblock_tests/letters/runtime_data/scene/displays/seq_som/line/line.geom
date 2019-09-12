layout(lines) in;
layout(line_strip,max_vertices=2) out;

uniform mat4 bl_model_view_projection_matrix;

uniform float shader_data[7];

void main(void)
{	
	vec3 start_vertex=vec3(shader_data[0],shader_data[1],shader_data[2]);
	vec3 end_vertex=vec3(shader_data[3],shader_data[4],shader_data[5]);
	gl_Position=bl_model_view_projection_matrix*vec4(start_vertex,1);
	EmitVertex();
	gl_Position=bl_model_view_projection_matrix*vec4(end_vertex,1);
	EmitVertex();
	EndPrimitive();
}
