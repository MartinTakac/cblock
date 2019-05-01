#if __VERSION__ < 130
attribute vec3 bl_vertex_location;
attribute vec2 bl_vertex_texture;
#else
in vec3 bl_vertex_location;
in vec2 bl_vertex_texture;
#endif

uniform mat4 bl_model_view_projection_matrix;

#if __VERSION__ < 130
varying vec2 texture_coordinate;
#else
out vec2 texture_coordinate;
#endif

void main(void)
{
	texture_coordinate=bl_vertex_texture;
	gl_Position=bl_model_view_projection_matrix*vec4(bl_vertex_location,1.);
}
