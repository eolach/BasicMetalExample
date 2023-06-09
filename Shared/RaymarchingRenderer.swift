//
//  RaymarchingRenderer.swift
//  BasicMetalExample
//
//  Created by Neil McEvoy on 2021-11-02.
//

import MetalKit
import MetalUI

final class RaymarchingRenderer: NSObject, MetalRendering {
    func createBuffers(device: MTLDevice) {}
    var time: Float = 0
    
    
    
    var commandQueue: MTLCommandQueue?
    var renderPipelineState: MTLRenderPipelineState?
    var vertexBuffer: MTLBuffer?
    var vertices: [MetalRenderingVertex] = []
    var pipelineState: MTLComputePipelineState!
    
    func createCommandQueue(device: MTLDevice) {
        commandQueue = device.makeCommandQueue()
    }
    
    func createPipelineState(
        withLibrary library: MTLLibrary?,
        forDevice device: MTLDevice)
    {
//        let vertexFunction = library?.makeFunction(name: "basic_vertex_function")
//        let fragmentFunction = library?.makeFunction(name: "basic_fragment_function")
//        let renderPipelineDescription = MTLRenderPipelineDescriptor()
//        renderPipelineDescription.colorAttachments[0].pixelFormat = .bgra8Unorm
//        renderPipelineDescription.vertexFunction = vertexFunction
//        renderPipelineDescription.fragmentFunction = fragmentFunction
//
       do {
//           guard let path = Bundle.main.path(forResource: "Raymarching", ofType: "metal") else {fatalError("Not path")}
//           let input = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
//           let library = try device.makeLibrary(source: input, options: nil)
           guard let kernel = library?.makeFunction(name: "compute") else {
               fatalError("Kernel not formed")
           }
           pipelineState = try device.makeComputePipelineState(function: kernel)
       } catch {
            print(error.localizedDescription)
        }
    }
//
//    func createBuffers(device: MTLDevice) {
//        vertexBuffer = device.makeBuffer(bytes: vertices,
//                                         length: MemoryLayout<MetalRenderingVertex>.stride*vertices.count,
//                                         options: [])
        
        
    

    
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        time += 0.01
        guard let drawable = view.currentDrawable,
              //let renderPassDescriptor = view.currentRenderPassDescriptor,
              let commandQueue = commandQueue else {
                  return
              }
        
//        let commandBuffer = commandQueue.makeCommandBuffer()
//        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
//        let commandEncoder = commandBuffer?.makeComputeCommandEncoder()
//        commandEncoder?.setRenderPipelineState(renderPipleState)
//        commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
//        commandEncoder?.drawPrimitives(type: .triangle,
//                                       vertexStart: 0,
//                                       vertexCount: vertices.count)
//
// MARK: New encoding
        // Command encoder
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
              let commandEncoder = commandBuffer.makeComputeCommandEncoder() else { fatalError() }
        commandEncoder.setComputePipelineState(pipelineState!)
        commandEncoder.setTexture(drawable.texture, index: 0)
        commandEncoder.setBytes(&time, length: MemoryLayout<Float>.size, index: 0)
         
        // Threads
        let w = pipelineState!.threadExecutionWidth
        let h = pipelineState!.maxTotalThreadsPerThreadgroup / w
        let threadsPerGroup = MTLSizeMake(w, h, 1)
        let threadsPerGrid = MTLSizeMake(Int(view.drawableSize.width),
                                         Int(view.drawableSize.height), 1)
        commandEncoder.dispatchThreads(threadsPerGrid, threadsPerThreadgroup: threadsPerGroup)
        commandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    
    }
}
