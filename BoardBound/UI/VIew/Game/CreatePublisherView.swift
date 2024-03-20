//
//  CreatePublisherView.swift
//  BoardBound
//
//  Created by Magali Leiva on 6/6/24.
//

import SwiftUI
import Combine

struct CreatePublisherView: View {
    @EnvironmentObject var vm: CreatePublisherViewModel
    @Binding var isCreatingPublisher: Bool
    @State var name: String = ""
    @State var showAlert = false
    @State var error = ""
    @State var alertMessage = ""
    @State var isError = false
    @Environment(\.dismiss) private var dismiss
    @Binding var publisherSheetShown: Bool
    
    var body: some View {
        
        if(vm.isBusy){
            HStack {
                Spacer()
                VStack {
                    Text("Board Bound")
                        .font(.largeTitle).foregroundColor(Color.white)
                        .padding([.top, .bottom], 40)
                        .shadow(radius: 10.0, x: 20, y: 10)
                    
                    ProgressView("Guardando").controlSize(.large).tint(.white).padding()
                    Spacer()
                }.background(LinearGradient(gradient: Gradient(colors: [.lightGreen, .darkGreen]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
                Spacer()
            }.background(LinearGradient(gradient: Gradient(colors: [.lightGreen, .darkGreen]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
        } else {
            VStack{
                
                Text("Nuevo editor")
                    .font(.title)
                    .padding()
                
                TextField("Nombre del editor", text: $name)
                    .padding()
                    .background(Color.themeTextField)
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
                
                Button(action: {
                    
                    if name.isEmpty  {
                        error = "Complete todos los campos para poder guardar el editor"
                        showAlert = true
                    } else {
                        error = ""
                        Task {
                            do {
                                let result = await vm.createPublisher(name: name)
                                switch result {
                                case .success:
                                    dismiss()
                                case .failure(let err):
                                    switch err {
                                    case .createPublisherError:
                                        isError = true
                                        showAlert = true
                                    }
                                }
                            }
                        }
                    }
                }) {
                    Text("Guardar editor")
                        .font(.headline)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.green)
                        .cornerRadius(15.0)
                        .shadow(radius: 10.0, x: 20, y: 10)
                }
                .padding(.top, 20)
                .alert(isPresented: $showAlert) {
                    showAlertCreateGame(error: error)
                }
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [.lightGreen, .darkGreen]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
        }
    }
    
    
    func showAlertCreateGame(error: String) -> Alert {
        var textoError = "Editor guardado correctamente"
        if isError {
            textoError = "Error al guardar editor"
        }
        if !error.isEmpty {
            textoError = error
        }
        return Alert(title: Text("Crear nuevo editor"), message: Text(textoError), dismissButton: .default(Text("OK")))
    }
    
}
