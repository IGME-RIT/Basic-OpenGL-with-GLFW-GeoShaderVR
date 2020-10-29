/*
Title: GeoShaderVR
File Name: geometry.glsl
Copyright ? 2020
Author: Niko Procopi
Written under the supervision of David I. Schwartz, Ph.D., and
supported by a professional development seed grant from the B. Thomas
Golisano College of Computing & Information Sciences
(https://www.rit.edu/gccis) at the Rochester Institute of Technology.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or (at
your option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/


#version 450 core

#define PASSTHROUGH 0
#define REAL 1

layout (triangles) in;
layout (triangle_strip) out;
layout (max_vertices = 3) out;

// Execute once for left eye and once for right eye
layout(invocations = 2) in;

in VertexData {
    vec2 uv;
    vec3 normal;
    vec3 tangent;
    vec3 bitangent;
} VertexIn[3];

out VertexData {
    vec2 uv;
    vec3 normal;
    vec3 tangent;
    vec3 bitangent;
} VertexOut;

uniform mat4 cameraView1;
uniform mat4 cameraView2;

void main(void)
{
	// first instance goes to first viewport
	// second instance goes to second viewport
	gl_ViewportIndex = gl_InvocationID;

    // Loop through every vertex in this primitive,
    // In this case, because it's a triangle, there are 3
    for (int i = 0; i < gl_in.length(); i++)
    {
        VertexOut.uv =          VertexIn[i].uv;
        VertexOut.normal =      VertexIn[i].normal;
        VertexOut.tangent =     VertexIn[i].tangent;
        VertexOut.bitangent =   VertexIn[i].bitangent;

        // Handle world-to-screen conversion for left eye
        if(gl_InvocationID == 0)
        {
            gl_Position = cameraView1 * gl_in[i].gl_Position;
        }
        
        // Handle world-to-screen conversion for right eye
        else
        {
            gl_Position = cameraView2 * gl_in[i].gl_Position;
        }

        EmitVertex();
    }

    // Notice we are inputting TRIANGLE and exporting TRIANGLE_STRIP,
    // by ending the TRIANLGE_STRIP primitive after 3 vertices, we 
    // get the equiavlent result of ordinary TRIANGLE
    EndPrimitive();
}