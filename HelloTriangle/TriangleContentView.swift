//
//  TriangleContentView.swift
//  HelloTriangle
//
//

import SwiftUI
import MetalKit

struct TriangleContentView: UIViewRepresentable {
    func makeCoordinator() -> TriangleRenderer {
        TriangleRenderer(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<TriangleContentView>) -> MTKView {
        // The view renders graphics and displays them onscreen
        let mtkView = MTKView()
        mtkView.delegate = context.coordinator
        mtkView.preferredFramesPerSecond = 60
        mtkView.enableSetNeedsDisplay = true
        mtkView.framebufferOnly = false
        mtkView.drawableSize = mtkView.frame.size
        mtkView.clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        mtkView.device = MTLCreateSystemDefaultDevice()
        return mtkView
    }
    
    func updateUIView(_ uiView: MTKView, context: UIViewRepresentableContext<TriangleContentView>) {
    }
}
