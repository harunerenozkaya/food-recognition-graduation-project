import SwiftUI
import ARKit
import RealityKit
import AVFoundation

struct CameraViewContainer: UIViewRepresentable {
    @Binding var isTooFar: Bool
    @Binding var flashOn: Bool
    @Binding var capturedImage: UIImage?
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        let config = ARWorldTrackingConfiguration()
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth) {
            config.frameSemantics = .sceneDepth
        }
        
        arView.session.delegate = context.coordinator
        arView.session.run(config)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        toggleTorch(on: flashOn)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    private func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                device.torchMode = on ? .on : .off
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used: \(error.localizedDescription)")
            }
        }
    }
    
    class Coordinator: NSObject, ARSessionDelegate {
        var parent: CameraViewContainer
        var capturedImageBuffer: CVPixelBuffer?
        
        init(parent: CameraViewContainer) {
            self.parent = parent
        }
        
        func session(_ session: ARSession, didUpdate frame: ARFrame) {
            
            let pixelBuffer = frame.capturedImage
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let context = CIContext(options: nil)
            guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return }
            let croppedCGImage = cgImage.cropping(to: .init(x: 375, y: 325, width: 775, height: 775))
            let croppedUIImage = UIImage(cgImage: croppedCGImage!, scale: 1 , orientation: .right)
            parent.capturedImage = croppedUIImage;
            
            guard let depthMap = frame.sceneDepth?.depthMap else { return }
            
            // Lock the buffer for reading
            CVPixelBufferLockBaseAddress(depthMap, .readOnly)
            defer { CVPixelBufferUnlockBaseAddress(depthMap, .readOnly) }
            
            // Get dimensions
            let widthDepth = CVPixelBufferGetWidth(depthMap)
            let heightDepth = CVPixelBufferGetHeight(depthMap)
            
            // Get center coordinates
            let centerX = widthDepth / 2
            let centerY = heightDepth / 2
            
            // Get pointer to the depth data
            guard let baseAddress = CVPixelBufferGetBaseAddress(depthMap) else { return }
            let bytesPerRow = CVPixelBufferGetBytesPerRow(depthMap)
            let index = centerY * bytesPerRow + centerX * MemoryLayout<Float32>.size
            
            // Get depth value at center
            let depthPointer = baseAddress.advanced(by: index).assumingMemoryBound(to: Float32.self)
            let depth = depthPointer.pointee
            
            // Convert depth to centimeters (depth is in meters)
            let depthInCm = depth * 100
            
            // Update warning state
            DispatchQueue.main.async {
                self.parent.isTooFar = depthInCm > 50
            }
        }
    }
}
