import SwiftUI
import RealityKit
import ARKit

struct ARCalculationView: View {
    @StateObject private var arViewModel = ARViewModel()
    @Environment(\.dismiss) private var dismiss
    @Binding var foodMeasurement: FoodMeasurement
    
    var body: some View {
        ZStack {
            ARViewContainer(arViewModel: arViewModel)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: { arViewModel.reset() }) {
                        Image(systemName: "arrow.counterclockwise.circle.fill")
                            .font(.system(size: 25))
                            .foregroundColor(.blue)
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                    .padding(.horizontal)
                }
                
                if arViewModel.isRoofCreated {
                    VStack(spacing: 8) {
                        HStack(spacing: 15) {
                        HStack(spacing: 15) {
                            VStack(spacing: 2) {
                                Text("Height")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                Slider(value: $arViewModel.areaHeight, in: 0...10, step: 0.1)
                                    .frame(width: 150)
                            }
                            .onAppear {
                                arViewModel.areaHeight = FoodHeightService.height[foodMeasurement.classId]!
                            }
                            
                            VStack(spacing: 2) {
                                Text("Roof Scale")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                Slider(value: $arViewModel.roofAreaScale, in: -80...80, step: 1)
                                    .frame(width: 150)
                            }
                        }
                        .padding(8)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(8)
                        
                        if let baseArea = arViewModel.calculatedBaseArea,
                           let roofArea = arViewModel.calculatedRoofArea {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 8) {
                                MeasurementText(
                                    label: "Base",
                                    value: String(format: "%.1f cm²", baseArea * 10000)
                                )
                                
                                MeasurementText(
                                    label: "Roof",
                                    value: String(format: "%.1f cm²", roofArea * 10000)
                                )
                                
                                MeasurementText(
                                    label: "Height",
                                    value: String(format: "%.1f cm", arViewModel.areaHeight)
                                )
                                
                                if let volume = arViewModel.calculatedVolume {
                                    MeasurementText(
                                        label: "Volume",
                                        value: String(format: "%.1f cm³", volume * 10000)
                                    )
                                }
                            }
                            .padding(8)
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                
                if let volume = arViewModel.calculatedVolume {
                    Button {
                        foodMeasurement.volume = Double(volume * 10000)
                        dismiss()
                    } label: {
                        Text("Complete")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

struct MeasurementText: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.caption)
                .bold()
                .foregroundColor(.white)
        }
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .padding(.horizontal, 30)
            .padding(.vertical, 10)
            .background(Color.blue)
            .cornerRadius(8)
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}




