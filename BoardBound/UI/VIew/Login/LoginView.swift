import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var vm: LoginViewModel
    @State var email = ""
    @State var password = ""
    var body: some View {
        NavigationView {
            VStack{
                if(vm.isBusy){
                    HStack {
                        Spacer()
                        VStack {
                            Text("Board Bound")
                                .font(.largeTitle).foregroundColor(Color.white)
                                .padding([.top, .bottom], 40)
                                .shadow(radius: 10.0, x: 20, y: 10)
                            
                            ProgressView("Login").controlSize(.large).tint(.white).padding()
                            Spacer()
                        }
                        Spacer()
                    }
                }else{
                    VStack {
                        Image("logoOnly")
                            .resizable()
                            .frame(width: 250, height: 250)
                            .cornerRadius(10.0)
                            .shadow(radius: 10.0, x: 20, y: 10)
                            .padding(.bottom, 50)
                        
                        VStack(alignment: .leading, spacing: 15) {
                            TextField("Email", text: $email)
                                .padding()
                                .background(Color.themeTextField)
                                .cornerRadius(20.0)
                                .shadow(radius: 10.0, x: 20, y: 10)
                            
                            SecureField("Contraseña", text: $password)
                                .padding()
                                .background(Color.themeTextField)
                                .cornerRadius(20.0)
                                .shadow(radius: 10.0, x: 20, y: 10)
                            
                        }.padding([.leading, .trailing], 27.5)
                        
                        Button(action: {
                            Task { await vm.logIn(email: email,password:password) }
                        }) {
                            Text("Iniciar sesión")
                                .font(.headline)
                                .padding()
                                .frame(width: 300, height: 50)
                                .background(Color.green)
                                .cornerRadius(15.0)
                                .shadow(radius: 10.0, x: 20, y: 10)
                        }.padding(.top, 50)
                        
                        Spacer()
                        HStack(spacing: 0) {
                            NavigationLink(destination: SignInView()) {
                                Text("Crear nueva cuenta nueva").foregroundColor(.black)
                            }
                        }
                    }
                }
            }.background(LinearGradient(gradient: Gradient(colors: [.lightGreen, .darkGreen]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
        }
    }
}

extension Color {
    static var themeTextField: Color {
        return Color(red: 220.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, opacity: 1.0)
    }
}
