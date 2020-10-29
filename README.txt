Documentation Author: Niko Procopi 2020

This tutorial was designed for Visual Studio 2019
If the solution does not compile, retarget the solution
to a different version of the Windows SDK. If you do not
have any version of the Windows SDK, it can be installed
from the Visual Studio Installer Tool

Welcome to GeometryShaderVR
Prerequisites:
   InstancedVR
   Other Geometry Shader tutorials on ATLAS

This tutorial shows how to use Geometry Shaders for something
more complex than particle effects. Although Geometry Shaders
have some potential for optimization, sometimes they can hurt
performance. This is one of the cases where Geometry Shaders are bad

In C++, we remove Instance Rendering, and only submit one draw 
per model. This is so the graphics pipeline only happens once for
each object we draw, and the geometry shader duplicates the 
geometry. We use the same viewport array technique as the previous
tutorial, and this time we do not need support for any OpenGL extensions

In the Vertex Shader, because we are exporting to a Geometry Shader
instead of directly to the rasterizer, we are required to have "out" as a
structure, we can't export individual elements, it won't work. Similarly,
we have "in" and "out" as structures in the Geometry Shader and Fragment
Shader too.

In the Geometry Shader, we take "triangles" in, and export "triangle strip".
To make this work, we call EmitVertex three times to make one triangle,
and then we use EndPrimitive to end the strip after 3 vertices. This makes
the visual result of triangle strip, look exactly the same as triangle list.
If we did not call EndPrimitive, then all the vertices would connect in one strip


Benchmark on GTX 1050:

Original, with no Instanced Rendering or Geometry Shader

	With blur, in center of world 
	Performance of Vertex shader and Fragment shader
		1st Eye: 0.427ms
		2nd Eye: 0.429ms
		Blur eyes: 1.66ms
		Full Frame: 2.54ms

	No blur, camera way off in the void
	Performance of Vertex shader
		1st Eye: 0.243ms
		2nd Eye: 0.248ms
		Full Frame: 0.502ms

Previous tutorial, with Instanced Rendering

	With blur, in center of world 
	Performance of Vertex shader and Fragment shader
		Both eyes: 0.855ms
		Blur eyes: 1.66ms
		Full Frame: 0.253ms

	No blur, camera way off in the void
	Performance of Vertex shader
		Both eyes: 0.487
		Full Frame: 0.503ms	

Geometry Shader

	With blur, in center of world
	Performance of VS, GS, and FS
		Both eyes: 1.85ms
		Blur eyes: 7.11ms
		Full frame: 8.9ms

	No blur, camera way off in the void
	Performance of VS and GS
		Both eyes: 1.195ms
		Full frame: 1.198ms
