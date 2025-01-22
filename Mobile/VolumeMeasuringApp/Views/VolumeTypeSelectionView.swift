import SwiftUI

struct VolumeTypeSelectionView: View {
    let foodImage: UIImage
    let processedImage: UIImage
    let detectedFoods: [FoodRecognitionViewModel.DetectedFood]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Which method would you like to use to measure the volume of your food?")
                .font(.title3)
                .fontWeight(.regular)
                .padding(.top, 40)
                .multilineTextAlignment(.center)

            
            Spacer()
            
            SelectionOptionView(
                title: "Average Portion Calculation",
                imageName: "chart.bar.fill",
                description: "Fast, standardized portions, less precise",
                destination: ResultView(
                    processedImage: processedImage,
                    nutritionInformations: NutritionInformationService.calculateFromDetectedFoods(detectedFoods: detectedFoods)
                )
            )
            
            SelectionOptionView(
                title: "Semi-Automatic AR Calculation",
                imageName: "cube.transparent.fill",
                description: "Slow, semi-automatic, more precise",
                destination: ARVolumeCalculationListView(
                    foodImage: foodImage,
                    processedImage: processedImage,
                    detectedFoods: detectedFoods
                )
            )
            
            Spacer()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SelectionOptionView<Destination: View>: View {
    let title: String
    let imageName: String
    let description: String
    let destination: Destination
    
    var body: some View {
        VStack(spacing: 15) {
            VStack(spacing: 15) {
                Image(systemName: imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue)
                
                Text(title)
                    .font(.title3.bold())
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 8)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            NavigationLink(destination: destination) {
                Text("Select")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
} 
