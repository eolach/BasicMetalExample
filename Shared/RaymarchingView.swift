//
//  RaymarchingView.swift
//  BasicMetalExample
//
//  Created by Neil McEvoy on 2021-11-02.
//

import MetalUI
import MetalKit

class RaymarchingView: MTKView, MetalPresenting {
    var renderer: MetalRendering!
    
    required init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 400, height: 400), device: MTLCreateSystemDefaultDevice())
        // Loads the default device,
        // sets the renderer as a delegate
        // and calls the configuration below for the MTKView
        // (Sets the pixel typs and the background colour
        configure(device: device)
        framebufferOnly = false
    }
    required init(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    func configureMTKView() {
        colorPixelFormat = .bgra8Unorm
        clearColor = MTLClearColor(red: 0.571, green: 1.0, blue: 0.85, alpha: 1)
    }
    
    /// Custom call to rendered tailored to whatever is to be rendered.
    /// Since the renderer is also a custom object, the content can be matched
    func renderer(forDevice device: MTLDevice) -> MetalRendering {
        RaymarchingRenderer(vertices: [
            MetalRenderingVertex(position: SIMD3(0, 1, 0), color: SIMD4(0, 1, 0, 1)),
            MetalRenderingVertex(position: SIMD3(-1, -1, 0), color: SIMD4(1, 1, 0, 1)),
            MetalRenderingVertex(position: SIMD3(1, -1, 0), color: SIMD4(0, 0, 1, 1)),
        ], device: device)
    }

}
