import Foundation

class ChatGPTService {
    private static let apiKey = APIConfig.chatGPTKey
    private static let apiUrl = URL(string: "https://api.openai.com/v1/chat/completions")!
    
    struct ChatGPTResponse: Codable {
        let choices: [Choice]
        
        struct Choice: Codable {
            let message: Message
        }
        
        struct Message: Codable {
            let content: String
        }
    }
    
    static func analyzeMeal(nutritionInfo: [NutritionInformation]) async throws -> String {
        var mealDescription = "Please analyze this meal nutritionally:\n\n"
        
        let totalCalories = nutritionInfo.reduce(0) { $0 + $1.calorie }
        let totalProtein = nutritionInfo.reduce(0) { $0 + $1.protein }
        let totalCarbs = nutritionInfo.reduce(0) { $0 + $1.carb }
        let totalFat = nutritionInfo.reduce(0) { $0 + $1.fat }
        
        mealDescription += "Total Nutritional Values:\n"
        mealDescription += "- Calories: \(String(format: "%.1f", totalCalories)) kcal\n"
        mealDescription += "- Protein: \(String(format: "%.1f", totalProtein))g\n"
        mealDescription += "- Carbohydrates: \(String(format: "%.1f", totalCarbs))g\n"
        mealDescription += "- Fat: \(String(format: "%.1f", totalFat))g\n\n"
        
        mealDescription += "Individual Foods:\n"
        for food in nutritionInfo {
            mealDescription += "- \(food.classLabel): \(String(format: "%.1f", food.gram))g, "
            mealDescription += "\(String(format: "%.1f", food.calorie)) kcal, "
            mealDescription += "\(String(format: "%.1f", food.protein))g protein, "
            mealDescription += "\(String(format: "%.1f", food.carb))g carbs, "
            mealDescription += "\(String(format: "%.1f", food.fat))g fat\n"
        }
        
        mealDescription += "\nPlease provide a comprehensive analysis of this meal in the following format:\n\n"
        mealDescription += "# Meal Analysis\n\n"
        mealDescription += "## Nutritional Balance\n"
        mealDescription += "[Analyze whether the meal is nutritionally balanced]\n\n"
        mealDescription += "## Health Benefits & Concerns\n"
        mealDescription += "[List potential health benefits and concerns]\n\n"
        mealDescription += "## Suggestions for Improvement\n"
        mealDescription += "[Provide suggestions if needed]\n\n"
        mealDescription += "## Dietary Suitability\n"
        mealDescription += "[Discuss suitable diets and lifestyles]\n\n"
        mealDescription += "\nPlease maintain this markdown format in your response."
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
            "model": "gpt-4o",
            "messages": [
                [
                    "role": "user",
                    "content": mealDescription
                ]
            ],
            "temperature": 0.5
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(ChatGPTResponse.self, from: data)
        let content = response.choices.first?.message.content ?? "Unable to analyze meal"
        
        return formatMarkdown(content)
    }
    
    private static func formatMarkdown(_ text: String) -> String {
        var formattedText = text
        
        formattedText = formattedText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        formattedText = formattedText.replacingOccurrences(
            of: "(?m)^#{1,6} ",
            with: "\n$0",
            options: .regularExpression
        )
        
        formattedText = formattedText.replacingOccurrences(
            of: "(?m)^[*-] .*$",
            with: "$0\n",
            options: .regularExpression
        )
        
        formattedText = formattedText.replacingOccurrences(
            of: "\n{3,}",
            with: "\n\n",
            options: .regularExpression
        )
        
        return formattedText
    }
}
