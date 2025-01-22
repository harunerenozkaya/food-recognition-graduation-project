import SwiftUI

struct FoodRecognitionView: View {
    let foodImage: UIImage
    @StateObject private var viewModel = FoodRecognitionViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showingFullScreenImage = false
    
    private var hasSelectedFoods: Bool {
        viewModel.detectedFoods.contains { $0.count > 0 }
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                LoadingView()
            } else {
                if let processedImage = viewModel.processedImage {
                    Image(uiImage: processedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: UIScreen.main.bounds.height * 0.4)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 10)
                        .padding()
                        .onTapGesture {
                            showingFullScreenImage = true
                        }
                    
                    if viewModel.detectedFoods.isEmpty {
                        Spacer()
                        Text("Unfortunately, no food is detected. Please try again.")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding()
                        Spacer()
                    } else {
                        List {
                            ForEach(viewModel.detectedFoods) { food in
                                HStack {
                                    Text(food.classLabel)
                                        .font(.headline)
                                    Spacer()
                                    HStack {
                                        Button(action: {
                                            viewModel.updateFoodCount(for: food, increment: false)
                                        }) {
                                            Image(systemName: "minus.circle.fill")
                                                .foregroundColor(.red)
                                                .frame(width: 44, height: 44)
                                                .background(Color.red.opacity(0.1))
                                                .cornerRadius(10)
                                        }
                                        .buttonStyle(BorderlessButtonStyle())
                                        
                                        Text("\(food.count)")
                                            .font(.title2)
                                            .bold()
                                            .frame(minWidth: 40)
                                        
                                        Button(action: {
                                            viewModel.updateFoodCount(for: food, increment: true)
                                        }) {
                                            Image(systemName: "plus.circle.fill")
                                                .foregroundColor(.green)
                                                .frame(width: 44, height: 44)
                                                .background(Color.green.opacity(0.1))
                                                .cornerRadius(10)
                                        }
                                        .buttonStyle(BorderlessButtonStyle())
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        
                        NavigationLink(destination: VolumeTypeSelectionView(
                            foodImage: foodImage,
                            processedImage: processedImage,
                            detectedFoods: viewModel.detectedFoods.filter { $0.count > 0 }
                        )) {
                            Text("Analyze")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(hasSelectedFoods ? Color.blue : Color.gray)
                                .cornerRadius(10)
                        }
                        .disabled(!hasSelectedFoods)
                        .padding()
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.analyzeFoodImage(foodImage)
        }
        .fullScreenCover(isPresented: $showingFullScreenImage) {
            ZoomableImageView(image: viewModel.processedImage ?? foodImage)
        }
    }
}

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Your food is being detected...")
                .font(.headline)
        }
    }
}

struct ZoomableImageView: View {
    let image: UIImage
    @Environment(\.dismiss) private var dismiss
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .scaleEffect(scale)
                    .offset(offset)
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                let delta = value / lastScale
                                lastScale = value
                                scale = min(max(scale * delta, 1), 4)
                            }
                            .onEnded { _ in
                                lastScale = 1.0
                            }
                    )
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                offset = CGSize(
                                    width: lastOffset.width + value.translation.width,
                                    height: lastOffset.height + value.translation.height
                                )
                            }
                            .onEnded { _ in
                                lastOffset = offset
                            }
                    )
                    .gesture(
                        TapGesture(count: 2)
                            .onEnded {
                                withAnimation {
                                    scale = scale > 1 ? 1 : 2
                                    offset = .zero
                                    lastOffset = .zero
                                }
                            }
                    )
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                    }
                }
            }
            .background(Color.black.opacity(0.8))
            .edgesIgnoringSafeArea(.all)
        }
    }
}
