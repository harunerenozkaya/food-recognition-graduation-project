import SwiftUI
import ARKit
import RealityKit
import AVFoundation

struct CaptureFoodView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isTooFar: Bool = false
    @State private var showingTips = false
    @State private var flashOn = false
    @State private var showFlashUnavailable = false
    @State private var capturedImage: UIImage?
    @State private var cameraViewRef: CameraViewContainer?
    @StateObject private var captureFoodViewModel = CaptureFoodViewModel()
    @State private var showPhotoConfirmation = false
    
    var body: some View {
        ZStack {
            CameraViewContainer(
                isTooFar: $isTooFar,
                flashOn: $flashOn,
                capturedImage: $capturedImage
            ).edgesIgnoringSafeArea(.all)
            
            GeometryReader { geometry in
                let squareSize = min(geometry.size.width, geometry.size.height) * 0.9
                
                ZStack {
                    Color.black
                        .mask(
                            Rectangle()
                                .overlay(
                                    Rectangle()
                                        .frame(width: squareSize, height: squareSize)
                                        .offset(y: -geometry.size.height * 0.1)
                                        .blendMode(.destinationOut)
                                )
                        )
                    
                    Rectangle()
                        .stroke(isTooFar ? Color.red : Color.white, lineWidth: 2)
                        .frame(width: squareSize, height: squareSize)
                        .offset(y: -geometry.size.height * 0.1)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }.edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "arrow.left.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    }
                    .padding()
                    
                    Spacer()
                    
                    Button(action: { showingTips = true }) {
                        Image(systemName: "questionmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    }
                    .padding()
                    
                    Button(action: {
                        if let device = AVCaptureDevice.default(for: .video), device.hasTorch {
                            flashOn.toggle()
                        } else {
                            showFlashUnavailable = true
                        }
                    }) {
                        Image(systemName: flashOn ? "bolt.fill" : "bolt.slash.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    }
                    .padding()
                }
                
                Spacer()
                

                if isTooFar {
                    Text("A bit closer, please!")
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 4)
                        .cornerRadius(8)
                        .padding(.bottom, 130)
                }
                                

                Button(action: {
                    if let image = capturedImage {
                        if flashOn {
                            flashOn = false
                        }
                        captureFoodViewModel.captureImage(image: image)
                        showPhotoConfirmation = true
                    }
                }) {
                    Circle()
                        .stroke(isTooFar ? Color.gray : Color.white, lineWidth: 3)
                        .frame(width: 70, height: 70)
                        .overlay(
                            Circle()
                                .fill(isTooFar ? Color.gray.opacity(0.5) : Color.white)
                                .frame(width: 60, height: 60)
                        )
                }
                .padding(.bottom, 50)
                .disabled(isTooFar)
            }
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $showPhotoConfirmation) {
            if let storedImage = captureFoodViewModel.storedImage {
                PhotoConfirmationView(capturedImage: storedImage)
            }
        }
        .sheet(isPresented: $showingTips) {
            TipsView()
        }
        .alert("Flash Unavailable", isPresented: $showFlashUnavailable) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Flash is not available on this device.")
        }
    }
}

struct TipsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Capture Tips")) {
                    TipRow(image: "square.dashed", text: "Keep food inside the square")
                    TipRow(image: "light.max", text: "Ensure good lighting")
                    TipRow(image: "ruler", text: "Keep device within 50cm of your food")
                    TipRow(image: "hand.raised.fill", text: "Hold device steady")
                }
            }
            .navigationTitle("How to Capture")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct TipRow: View {
    let image: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: image)
                .frame(width: 30)
                .foregroundColor(.blue)
            Text(text)
        }
        .padding(.vertical, 4)
    }
} 
