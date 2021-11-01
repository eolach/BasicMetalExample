//
//  BasicMetalRenderer.swift
//  BasicMetalExample
//
//  Created by Neil McEvoy on 2021-11-01.
//

import MetalKit
import MetalUI

final class BasicMetalRenderer: NSObject, MetalRendering {
    var commandQueue: MTLCommandQueue?
    var renderPipelineState: MTLRenderPipelineState?
    var vertexBuffer: MTLBuffer?
    var vertices: [MetalRenderingVertex] = []
    
    func createCommandQueue(device: MTLDevice) {
        commandQueue = device.makeCommandQueue()
    }
    
    func createPipelineState(
        withLibrary library: MTLLibrary?,
        forDevice device: MTLDevice)
    {
        let vertexFunction = library?.makeFunction(name: "basic_vertex_function")
        let fragmentFunction = library?.makeFunction(name: "basic_fragment_function")
        let renderPipelineDescription = MTLRenderPipelineDescriptor()
        renderPipelineDescription.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineDescription.vertexFunction = vertexFunction
        renderPipelineDescription.fragmentFunction = fragmentFunction
        
        do {
            renderPipelineState = try device.makeRenderPipelineState(descriptor: renderPipelineDescription)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func createBuffers(device: MTLDevice) {
        vertexBuffer = device.makeBuffer(bytes: vertices,
                                         length: MemoryLayout<MetalRenderingVertex>.stride*vertices.count,
                                         options: [])
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let renderPassDescriptor = view.currentRenderPassDescriptor,
              let commandQueue = commandQueue,
              let renderPipleState = renderPipelineState else {
                  return
              }
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        commandEncoder?.setRenderPipelineState(renderPipleState)
        commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
        
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    
    }
}
