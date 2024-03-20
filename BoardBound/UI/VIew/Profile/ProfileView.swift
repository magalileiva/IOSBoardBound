import SwiftUI

struct ProfileView: View {

    @ObservedObject private var viewModel = ProfileViewModel()
    var userId: Int = UserDefaults.standard.integer(forKey: "userId")
    var username: String = UserDefaults.standard.string(forKey: "username") ?? ""
    var email: String = UserDefaults.standard.string(forKey: "email") ?? ""
    
    var body: some View {
        VStack {
            VStack {
                Text("Perfil de \(username)")
                    .font(.title)
                    .padding(.top)
                
                Text("Email: \(email)")
                    .padding(.bottom)
                
                Button(action: {
                    // Acción para cambiar la contraseña
                }) {
                    Text("Cambiar contraseña")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        
            VStack(alignment: .leading, spacing: 20) {
                if let createdMatchesCount = viewModel.info?.createdMatches.count {
                    Text("Partidas creadas: \(createdMatchesCount)")
                        .font(.headline)
                } else {
                    Text("Partidas creadas: 0")
                        .font(.headline)
                }
                
                if let createdMatchesCount = viewModel.info?.playedMatches.count {
                    Text("Partidas jugadas: \(createdMatchesCount)")
                        .font(.headline)
                } else {
                    Text("Partidas jugadas: 0")
                        .font(.headline)
                }
            }
            .padding()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(gradient: Gradient(colors: [.lightGreen, .darkGreen]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
        .onAppear {
            viewModel.getinfoUser()
        }
    }
    
}
