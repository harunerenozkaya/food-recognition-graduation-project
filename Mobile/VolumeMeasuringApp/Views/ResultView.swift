import SwiftUI
import MarkdownUI

struct ResultView: View {
    let processedImage: UIImage
    let nutritionInformations: [NutritionInformation]
    @Environment(\.dismiss) private var dismiss
    @State private var showingStartView = false
    @State private var mealAnalysis: String = "Analyzing your meal..."
    @State private var isLoadingAnalysis = true
    @State private var isAnalysisExpanded = false
    
    private var totalGram: Double {
        nutritionInformations.reduce(0) { $0 + $1.gram }
    }
    
    private var totalCalorie: Double {
        nutritionInformations.reduce(0) { $0 + $1.calorie }
    }
    
    private var totalCarb: Double {
        nutritionInformations.reduce(0) { $0 + $1.carb }
    }
    
    private var totalProtein: Double {
        nutritionInformations.reduce(0) { $0 + $1.protein }
    }
    
    private var totalFat: Double {
        nutritionInformations.reduce(0) { $0 + $1.fat }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                Image(uiImage: processedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: UIScreen.main.bounds.height * 0.3)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 10)
                    .padding()
                

                VStack(spacing: 15) {
                    Text("Total Nutritions")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 20) {
                        NutritionValueView(title: "Weight", value: totalGram, unit: "g")
                        NutritionValueView(title: "Calories", value: totalCalorie, unit: "kcal")
                    }
                    
                    HStack(spacing: 20) {
                        NutritionValueView(title: "Carbs", value: totalCarb, unit: "g")
                        NutritionValueView(title: "Protein", value: totalProtein, unit: "g")
                        NutritionValueView(title: "Fat", value: totalFat, unit: "g")
                    }
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal)
                

                VStack(alignment: .leading, spacing: 15) {
                    Button(action: {
                        withAnimation {
                            isAnalysisExpanded.toggle()
                        }
                    }) {
                        HStack {
                            Text("AI Analysis")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: isAnalysisExpanded ? "chevron.up" : "chevron.down")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    if isAnalysisExpanded {
                        if isLoadingAnalysis {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        } else {
                            Markdown(mealAnalysis)
                                .markdownTheme(.basic)
                                .textScale(.secondary)
                        }
                    }
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal)
                

                VStack(alignment: .leading, spacing: 15) {
                    Text("Individual Nutritions")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    ForEach(nutritionInformations) { nutrition in
                        FoodItemCard(nutrition: nutrition)
                    }
                }
                

                Button {
                    showingStartView = true
                } label: {
                    Text("New Analysis")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $showingStartView) {
            StartView()
        }
        .task {
            do {
                let analysis = try await ChatGPTService.analyzeMeal(nutritionInfo: nutritionInformations)
                mealAnalysis = analysis
                isLoadingAnalysis = false
            } catch {
                mealAnalysis = "Unable to analyze meal: \(error.localizedDescription)"
                isLoadingAnalysis = false
            }
        }
    }
}


struct NutritionValueView: View {
    let title: String
    let value: Double
    let unit: String
    
    var body: some View {
        VStack(spacing: 5) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(String(format: "%.1f %@", value, unit))
                .font(.headline)
        }
    }
}

struct FoodItemCard: View {
    let nutrition: NutritionInformation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(nutrition.classLabel)
                .font(.headline)
            
            HStack {
                Text(String(format: "%.1f g", nutrition.gram))
                    .foregroundColor(.secondary)
                Spacer()
                Text(String(format: "%.1f kcal", nutrition.calorie))
                    .foregroundColor(.blue)
            }
            
            HStack(spacing: 15) {
                Text("Carbs: \(String(format: "%.1f g", nutrition.carb))")
                Text("Protein: \(String(format: "%.1f g", nutrition.protein))")
                Text("Fat: \(String(format: "%.1f g", nutrition.fat))")
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

extension NutritionInformation: Identifiable {
    var id: String {
        "\(classLabel)_\(UUID())"
    }
} 
