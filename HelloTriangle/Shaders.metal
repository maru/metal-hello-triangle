//
//  Shaders.metal
//  HelloTriangle
//
// A vertex shader is simply a tiny program that runs on the GPU,
// written in a C++-like language called the Metal Shading Language.

#include <metal_stdlib>
using namespace metal;

#include "definitions.h"

struct Fragment {
    float4 position [[position]];
    float4 color;
};

// This function ("program") will be called for every vertex.
// It transforms a vertex with a 2D position and a color
// into a fragment with the same coordinates and color.
vertex Fragment vertexShader(const device Vertex *vertexArray [[buffer(0)]],
                             unsigned int vid [[vertex_id]]) {

    // Get the correct vertex
    Vertex input = vertexArray[vid];

    Fragment output;
    output.position = float4(input.position.x, input.position.y,
                             0.0,  // z
                             1.0); // w (scale)
    output.color = input.color;
    return output;
}


fragment float4 fragmentShader(Fragment input [[stage_in]]) {
    return input.color;
}
