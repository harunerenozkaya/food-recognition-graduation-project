import Foundation
import UIKit

class FoodRecognitionViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var detectedFoods: [DetectedFood] = []
    @Published var processedImage: UIImage?
    @Published var error: String?
    
    struct DetectedFood: Identifiable {
        let id = UUID()
        let classLabel: String
        let classId: Int
        var count: Int
    }
    
    func analyzeFoodImage(_ image: UIImage) async {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        do {
            let response = try await sendImagesToServer(images: [(imageData, "food.jpg")])
            
            // Process predictions and count occurrences
            var foodCounts: [String: (count: Int, classId: Int)] = [:]
            for result in response.results {
                for prediction in result.predictions {
                    // Capitalize first letter of class label
                    let capitalizedLabel = prediction.classLabel.prefix(1).uppercased() + prediction.classLabel.dropFirst()
                    foodCounts[capitalizedLabel, default: (0, prediction.classId)].count += 1
                }
            }
            
            // Convert to DetectedFood array
            let detectedFoods = foodCounts.map { food in
                DetectedFood(classLabel: food.key, 
                           classId: food.value.classId,
                           count: food.value.count)
            }.sorted { $0.classLabel < $1.classLabel }
            
            // Draw masks on the image
            if let firstResult = response.results.first {
                let processedImage = drawMasks(on: image, predictions: firstResult.predictions)
                
                DispatchQueue.main.async {
                    self.processedImage = processedImage
                    self.detectedFoods = detectedFoods
                    self.isLoading = false
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.error = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    func updateFoodCount(for food: DetectedFood, increment: Bool) {
        if let index = detectedFoods.firstIndex(where: { $0.id == food.id }) {
            var updatedFoods = detectedFoods
            let newCount = max(0, detectedFoods[index].count + (increment ? 1 : -1))
            updatedFoods[index] = DetectedFood(
                classLabel: food.classLabel,
                classId: food.classId,
                count: newCount
            )
            
            DispatchQueue.main.async {
                self.detectedFoods = updatedFoods
            }
            
        }
    }
    
    private func drawMasks(on image: UIImage, predictions: [Prediction]) -> UIImage {
        let colors: [UIColor] = [.green, .blue, .red, .yellow, .purple, .orange, .black, .brown, .magenta]

        var classIdToColor: [Int: UIColor] = [:]
        
        let renderer = UIGraphicsImageRenderer(size: image.size)
        
        let processedImage = renderer.image { context in
            image.draw(in: CGRect(origin: .zero, size: image.size))
            
            let cgContext = context.cgContext
            
            for (index, prediction) in predictions.enumerated() {
                let color = classIdToColor[prediction.classId] ?? colors[index % colors.count]
                classIdToColor[prediction.classId] = color
                
                let points = prediction.maskPoints.map {
                    CGPoint(x: $0[0], y: $0[1])
                }
                
                let path = CGMutablePath()
                if points.count > 0 {
                    path.move(to: points[0])
                    for point in points.dropFirst() {
                        path.addLine(to: point)
                    }
                    path.closeSubpath()
                }
                
                cgContext.setStrokeColor(color.cgColor)
                cgContext.setLineWidth(2.0)
                cgContext.setFillColor(color.withAlphaComponent(0.3).cgColor)
                
                cgContext.addPath(path)
                cgContext.drawPath(using: .fillStroke)
                
                if let firstPoint = points.first {
                    let label = prediction.classLabel
                    let attributes: [NSAttributedString.Key: Any] = [
                        .font: UIFont.boldSystemFont(ofSize: 12),
                        .foregroundColor: UIColor.white
                    ]
                    
                    let background = CGRect(x: firstPoint.x, y: firstPoint.y - 20, width: 100, height: 20)
                    cgContext.setFillColor(UIColor.black.withAlphaComponent(0.7).cgColor)
                    cgContext.fill(background)
                    
                    label.draw(at: CGPoint(x: firstPoint.x + 5, y: firstPoint.y - 18),
                             withAttributes: attributes)
                }
            }
        }
        
        return processedImage
    }
} 
