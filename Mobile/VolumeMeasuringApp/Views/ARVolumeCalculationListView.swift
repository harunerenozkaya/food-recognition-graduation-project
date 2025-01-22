import SwiftUI

struct FoodMeasurement {
    var classLabel: String
    var classId: Int
    var volume: Double
    var gram: Double
}

struct ARVolumeCalculationListView: View {
    let foodImage: UIImage
    let processedImage: UIImage
    let detectedFoods: [FoodRecognitionViewModel.DetectedFood]
    @State private var showingFullScreenImage = false
    @State private var selectedFood: Bool = false
    @Environment(\.dismiss) private var dismiss
    @State private var navigateToContent: Bool = false
    @State private var navigateToResult = false
    
    @State private var foodMeasurements: [String: [FoodMeasurement]] = [:]
    
    init(foodImage: UIImage, processedImage: UIImage, detectedFoods: [FoodRecognitionViewModel.DetectedFood]) {
        self.foodImage = foodImage
        self.processedImage = processedImage
        self.detectedFoods = detectedFoods
        
        var initialMeasurements: [String: [FoodMeasurement]] = [:]
        
        for food in detectedFoods {
            let measurements = (0..<food.count).map { _ in
                FoodMeasurement(
                    classLabel: food.classLabel,
                    classId: food.classId,
                    volume: 0.0,
                    gram: 0.0
                )
            }
            initialMeasurements[food.classLabel] = measurements
        }
        
        _foodMeasurements = State(initialValue: initialMeasurements)
    }
    
    private var allFoodsMeasured: Bool {
        for (_, measurements) in foodMeasurements {
            for measurement in measurements {
                if measurement.gram <= 0 {
                    return false
                }
            }
        }
        return !foodMeasurements.isEmpty
    }
    
    @State private var selectedFoodLabel: String = ""
    @State private var selectedFoodIndex: Int = 0
    
    var body: some View {
        VStack {
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
            
            List {
                ForEach(detectedFoods) { food in
                    ForEach(0..<food.count, id: \.self) { index in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(food.classLabel)
                                    .font(.headline) +
                                (food.count > 1 ? Text(" #\(index + 1)")
                                    .font(.callout)
                                    .foregroundColor(.gray) : Text(""))
                            }
                            
                            Spacer()
                            
                            if let measurement = foodMeasurements[food.classLabel]?[index],
                               measurement.gram > 0 {
                                Text(String(format: "%.1f g", measurement.gram))
                                    .font(.headline)
                                    .foregroundColor(.blue)
                            } else {
                                Button {
                                    selectedFoodLabel = food.classLabel
                                    selectedFoodIndex = index
                                    navigateToContent = true
                                } label: {
                                    Image(systemName: "ruler.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.blue)
                                        .frame(width: 30, height: 30)
                                        .padding(7)
                                        .background(Color.blue.opacity(0.1))
                                        .clipShape(Circle())
                                }
                                .frame(width: 44, height: 44)
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .listStyle(PlainListStyle())
            
            if allFoodsMeasured {
                Button {
                    navigateToResult = true
                } label: {
                    Text("Learn What You Eat!")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .navigationTitle("Select Food to Measure")
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $showingFullScreenImage) {
            ZoomableImageView(image: processedImage)
        }
        .navigationDestination(isPresented: $navigateToContent) {
            ARCalculationView(foodMeasurement: Binding(
                get: {
                    foodMeasurements[selectedFoodLabel]?[selectedFoodIndex] ?? FoodMeasurement(classLabel: "", classId: 0, volume: 0, gram: 0)
                },
                set: { newValue in
                    var newValueC = newValue
                    let volume = newValue.volume
                    let gram = VolumeToGramService.convertVolumeToGram(classId: newValue.classId, volume: volume)
                    newValueC.gram = gram
                    foodMeasurements[selectedFoodLabel]?[selectedFoodIndex] = newValueC
                }
            ))
        }
        .navigationDestination(isPresented: $navigateToResult) {
            ResultView(
                processedImage: processedImage,
                nutritionInformations: NutritionInformationService.calculateFromFoodMeasurements(
                    foodMeasurements: Array(foodMeasurements.values.flatMap { $0 })
                )
            )
        }
    }
}
