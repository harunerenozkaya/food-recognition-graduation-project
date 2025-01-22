import SwiftUI

struct PhotoConfirmationView: View {
    @Environment(\.dismiss) private var dismiss
    let capturedImage: UIImage
    
    var body: some View {
        VStack {
            Image(uiImage: capturedImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
            
            Text("Do you want to continue with this photo?")
                .font(.headline)
                .padding()
            
            HStack(spacing: 20) {
                Button(action: {
                    dismiss()
                }) {
                    Text("Cancel")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: FoodRecognitionView(foodImage: capturedImage)) {
                    Text("Continue")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
        .navigationBarHidden(true)
    }
} 
