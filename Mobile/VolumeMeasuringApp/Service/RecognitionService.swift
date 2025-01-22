import Foundation
import UIKit

struct MultiImageResponse: Codable {
    let results: [ImagePredictionResponse]
}

struct ImagePredictionResponse: Codable {
    let filename: String
    let success: Bool
    let predictions: [Prediction]
    let imageInfo: ImageInfo
    
    enum CodingKeys: String, CodingKey {
        case filename
        case success
        case predictions
        case imageInfo = "image_info"
    }
}

struct Prediction: Codable {
    let maskPoints: [[Double]]
    let classId: Int
    let classLabel: String
    let confidence: Double
    
    enum CodingKeys: String, CodingKey {
        case maskPoints = "mask_points"
        case classId = "class_id"
        case classLabel = "class_label"
        case confidence
    }
}

struct ImageInfo: Codable {
    let width: Int
    let height: Int
}

func sendImagesToServer(images: [(Data, String)]) async throws -> MultiImageResponse {
    let url = URL(string: "http://172.20.10.3:8000/api/v1/predict")!
    let boundary = "Boundary-\(UUID().uuidString)"
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    var body = Data()
    
    for (_, (imageData, filename)) in images.enumerated() {
        body.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"files\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
    }
    
    body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
    request.httpBody = body
    
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
        throw URLError(.badServerResponse)
    }
    
    let decoder = JSONDecoder()
    return try decoder.decode(MultiImageResponse.self, from: data)
}

