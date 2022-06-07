//
//  Renderer.swift
//  HelloTriangle
//
// Everything in Metal is a triangle
//

import MetalKit

enum Color {
    static let red: vector_float4 = [1, 0, 0, 1]
    static let green: vector_float4 = [0, 1, 0, 1]
    static let blue: vector_float4 = [0, 0, 1, 1]
}

let InitialVertices = [
    Vertex(position: [-1.0, -1.0], color: Color.red),
    Vertex(position: [ 1.0, -1.0], color: Color.green),
    Vertex(position: [ 0.0,  1.0], color: Color.blue),
]

class TriangleRenderer : NSObject, MTKViewDelegate {
    var parent: TriangleContentView
    var device: MTLDevice! = nil
    var commandQueue: MTLCommandQueue! = nil
    var pipelineState: MTLRenderPipelineState! = nil
    let vertexBuffer: MTLBuffer
    var vertices: [Vertex]
    
    init(_ parent: TriangleContentView) {
        self.parent = parent

        // The device is the connection to the GPU
        self.device = MTLCreateSystemDefaultDevice()

        // Create a CommandQueue
        self.commandQueue = device.makeCommandQueue()
        
        // Precompiled shaders
        let defaultLibrary = device.makeDefaultLibrary()!
        let vertexProgram = defaultLibrary.makeFunction(name: "vertexShader")
        let fragmentProgram = defaultLibrary.makeFunction(name: "fragmentShader")

        // Set up the render pipeline configuration
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexProgram
        pipelineDescriptor.fragmentFunction = fragmentProgram
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        // Compile the pipeline configuration
        pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        
        // Create my Vertex Array
        self.vertices = InitialVertices
        vertexBuffer = device.makeBuffer(
            bytes: self.vertices,
            length: self.vertices.count * MemoryLayout<Vertex>.stride,
            options: []
        )!
        super.init()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable else { return }

        let commandBuffer = commandQueue.makeCommandBuffer()!
        
        // Configure which texture is being rendered to this object
        let rendererPassDescriptor = view.currentRenderPassDescriptor!
        rendererPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0, 0, 0, 1.0)
        rendererPassDescriptor.colorAttachments[0].loadAction = .clear
        rendererPassDescriptor.colorAttachments[0].storeAction = .store
        
        // Create a render command
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: rendererPassDescriptor)!
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: self.vertices.count)
        renderEncoder.endEncoding()
        
        // Present the new texture and commit the transaction
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
