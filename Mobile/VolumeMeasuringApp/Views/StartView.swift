import SwiftUI

struct StartView: View {
    @State private var showMainView = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "cube.transparent.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .foregroundColor(.blue)
                    .padding(.top, 60)
                
                Text("Foodyze")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(.primary)
                    .padding(.top, 20)
                
                Spacer()
                
                Text("Analyze your food and\nlearn what you eat!")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button(action: {
                    showMainView = true
                }) {
                    Text("Analyze")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(15)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 60)
            }
            .navigationDestination(isPresented: $showMainView) {
                CaptureFoodView()
            }
            .navigationBarHidden(true)
        }
    }
}
