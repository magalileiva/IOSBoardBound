//
//  CreateGameView.swift
//  BoardBound
//
//  Created by Magali Leiva on 23/5/24.
//

import SwiftUI
import Combine

struct CreateGameView: View {
    @EnvironmentObject var vm: CreateGameViewModel
    @Binding var isCreatingGame: Bool
    @State var name: String = ""
    @State var playerNumber: String = ""
    @State var duration: String = ""
    @State var suggestedAge: String = ""
    @State var urlImage: String = ""
    @State var difficulty: DifficultyEnum = .easy
    @State var showAlert = false
    @State var error = ""
    @State var alertMessage = ""
    @State var selectedPublisher: BoardGamePublisher? = nil
    @State var isError = false
    @State var isCreatingPublisher = false
    @State var publisherSheetShown = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            VStack{
                
                Text("Nuevo juego")
                    .font(.title)
                    .padding()
                    
                HStack{
                    Picker("Editor", selection: $selectedPublisher) {
                        Text("Seleccione un valor").tag(Optional<String>(nil))
                        ForEach(vm.publishers) { publisher in
                            Text(publisher.name).tag(publisher as BoardGamePublisher?)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    .padding()
                    .background(Color.themeTextField)
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
                    
                    Button(action: {
                        isCreatingPublisher = true
                    }) {
                        Image(systemName: "waveform.badge.plus")
                            .font(.title3)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.clear)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }.sheet(isPresented: $isCreatingPublisher) {
                        CreatePublisherView(isCreatingPublisher: $isCreatingPublisher, publisherSheetShown: $publisherSheetShown)
                    }
                    .onReceive(Just(publisherSheetShown)) { publisherSheetShown in
                        if !publisherSheetShown {
                            vm.fetchPublishers() // Actualizar los datos cuando se cierra la hoja del editor
                        }
                    }
                }
                
                
                TextField("Nombre del juego", text: $name)
                    .padding()
                    .background(Color.themeTextField)
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
                
                TextField("Número de jugadores", text: $playerNumber)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color.themeTextField)
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
                    .textContentType(.oneTimeCode)
                    .onChange(of: playerNumber, initial: true) {
                        self.playerNumber = self.playerNumber.filter { $0.isNumber }
                    }
                
                TextField("Duración (minutos)", text: $duration)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color.themeTextField)
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
                    .textContentType(.oneTimeCode)
                    .onChange(of: duration, initial: true) {
                        self.duration = self.duration.filter { $0.isNumber }
                    }
                
                TextField("Edad sugerida", text: $suggestedAge)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color.themeTextField)
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
                    .textContentType(.oneTimeCode)
                    .onChange(of: suggestedAge, initial: true) {
                        self.suggestedAge = self.suggestedAge.filter { $0.isNumber }
                    }
                
                TextField("URL de la imagen", text: $urlImage)
                    .padding()
                    .background(Color.themeTextField)
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
                
                if let imageUrl = URL(string: urlImage), !urlImage.isEmpty {
                    AsyncImage(url: imageUrl) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 100, height: 100)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                        @unknown default:
                            Image(systemName: "exclamationmark.triangle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .foregroundColor(.red)
                        }
                    }
                }
                
                Picker("Dificultad", selection: $difficulty) {
                    ForEach(DifficultyEnum.allCases, id: \.self) { difficulty in
                        if (difficulty.rawValue=="EASY"){Text("Facil")}
                        if (difficulty.rawValue=="MEDIUM"){Text("Medio")}
                        if (difficulty.rawValue=="HARD"){Text("Dificil")}
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Button(action: {
                    
                    if selectedPublisher == nil || name.isEmpty || playerNumber.isEmpty || duration.isEmpty || suggestedAge.isEmpty || urlImage.isEmpty || difficulty.rawValue.isEmpty {
                        error = "Complete todos los campos para poder guardar el juego"
                        showAlert = true
                    } else {
                        error = ""
                        Task {
                            do {
                                let result = await vm.createGame(name: name, playerNumber: playerNumber, duration: duration, suggestedAge: suggestedAge, urlImage: urlImage, difficulty: difficulty.rawValue, publisher: selectedPublisher!)
                                switch result {
                                case .success:
                                    isError = false
                                    showAlert = true
                                    isCreatingGame = false
                                    presentationMode.wrappedValue.dismiss()
                                case .failure(let err):
                                    switch err {
                                    case .createGameError:
                                        isError = true
                                        showAlert = true
                                    }
                                }
                            }
                        }
                    }
                }) {
                    Text("Guardar Juego")
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
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isCreatingGame = false
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Volver")
                        }
                    }
                }
            }
            .onAppear { vm.fetchPublishers() }
        }
    }
    
    enum DifficultyEnum: String, CaseIterable {
        case easy = "EASY"
        case medium = "MEDIUM"
        case hard = "HARD"
    }
    
    func showAlertCreateGame(error: String) -> Alert {
        var textoError = "Juego guardado correctamente"
        if isError {
            textoError = "Error al guardar juego"
        }
        if !error.isEmpty {
            textoError = error
        }
        return Alert(title: Text("Crear nuevo Juego"), message: Text(textoError), dismissButton: .default(Text("OK")))
    }
}
