//
//  SignInView.swift
//  BoardBound
//
//  Created by Magali Leiva on 12/5/24.
//

import SwiftUI

struct SignInView: View {
    
    @EnvironmentObject var vm: SignInViewModel
    
    @State var email = ""
    @State var password = ""
    @State var userName = ""
    @State var showAlert = false
    @State var isError = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
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
                        
                        TextField("Nombre de usuario", text: $userName)
                            .padding()
                            .background(Color.themeTextField)
                            .cornerRadius(20.0)
                            .shadow(radius: 10.0, x: 20, y: 10)
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
                        Task {
                            do {
                                let result = await vm.signIn(username: userName, email: email, password: password)
                                switch result {
                                    case .success:
                                        isError = false
                                        showAlert = true
                                        presentationMode.wrappedValue.dismiss()
                                    case .failure(let error):
                                        switch error {
                                            case .signInError:
                                            isError = true
                                            showAlert = true
                                            
                                        }
                                }
                            }
                        }
                    }) {
                        Text("Crear cuenta")
                            .font(.headline)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.green)
                            .cornerRadius(15.0)
                            .shadow(radius: 10.0, x: 20, y: 10)
                    }
                        .padding(.top, 50)
                        .alert(isPresented: $showAlert) {
                            showAlertSignIn()
                    }
                    Spacer()
                }
            }
        }.background(LinearGradient(gradient: Gradient(colors: [.lightGreen, .darkGreen]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
    }
    
    func showAlertSignIn() -> Alert {
        var textoError = "Cuenta creada correctamente"
        if isError {
            textoError = "Error al crear cuenta"
        }
        if email == "" {
            textoError = "Email vacio completelo para crear cuenta"
        }else if password == "" {
            textoError = "Contraseña vacia completelo para crear cuenta"
        }else if userName == "" {
            textoError = "Username vacio completelo para crear cuenta"
        }
        return Alert(title: Text("Crear nueva cuenta"), message: Text(textoError), dismissButton: .default(Text("OK")))
    }
}
