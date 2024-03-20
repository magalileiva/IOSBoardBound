import SwiftUI
import MapKit

struct CreateMatchView: View {
    
    @EnvironmentObject var vm: CreateMatchViewModel
    @Binding var isCreatingMatch: Bool
    @State var selectedGame: BoardGame? = nil
    @State var numberOfPlayers: Int = 2
    @State var address: String = ""
    @State var selectedDate: Date = Date()
    @State var isSelectedDate: Bool = false
    @State var selectedHour: String = "0"
    @State var selectedMinute: String = "0"
    @State var showAlert = false
    @State var isError: Int = 0
    @State private var mapCoordinate: CLLocationCoordinate2D?
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.331516, longitude: -122.030033),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    @Environment(\.presentationMode) var presentationMode
    
    private var currentDate: Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    }
    
    private var hours: [Int] {
        Array(0..<24)
    }
    
    private var minutes: [Int] {
        Array(stride(from: 0, through: 45, by: 15))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Section(header: Text("Selecciona el juego")) {
                    Picker("Juego", selection: $selectedGame) {
                        Text("Seleccione un valor").tag(Optional<String>(nil))
                        ForEach(vm.games) { game in
                            Text(game.name).tag(game as BoardGame?)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    .padding()
                    .background(Color.themeTextField)
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
                }
                
                Section(header: Text("Número de jugadores")) {
                    Stepper(value: $numberOfPlayers, in: 2...(selectedGame?.playerNumber ?? 2)) {
                        Text("\(numberOfPlayers) jugadores")
                    }
                    .padding()
                    .background(Color.themeTextField)
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
                }
                
                Section(header: Text("Lugar de la partida")) {
                    HStack {
                        TextField("Ingrese una dirección", text: $address)
                            .padding()
                            .background(Color.themeTextField)
                            .cornerRadius(20.0)
                            .shadow(radius: 10.0, x: 20, y: 10)
                        
                        Button(action: {
                            self.searchAddress()
                        }) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 10)
                    }
                    
                    if let coordinate = mapCoordinate {
                        MapView(coordinate: coordinate, region: $region)
                            .frame(height: 300)
                            .edgesIgnoringSafeArea(.all)
                            .cornerRadius(20.0)
                            .shadow(radius: 10.0, x: 20, y: 10)
                    } else {
                        MapView(region: $region)
                            .frame(height: 300)
                            .edgesIgnoringSafeArea(.all)
                            .cornerRadius(20.0)
                            .shadow(radius: 10.0, x: 20, y: 10)
                    }
                }
                
                Section(header: Text("Día y hora de la partida")) {
                    DatePicker("Fecha", selection: $selectedDate, in: currentDate..., displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding()
                        .background(Color.themeTextField)
                        .cornerRadius(20.0)
                        .shadow(radius: 10.0, x: 20, y: 10)
                        .onChange(of: selectedDate){
                            isSelectedDate = true
                        }
                    
                    HStack {
                        Picker("Hour", selection: $selectedHour) {
                            ForEach(0..<24) { index in
                                Text("\(hours[index])").tag("\(hours[index])")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 80)
                        .clipped()
                        
                        Text(":")
                        
                        Picker("Minute", selection: $selectedMinute) {
                            ForEach(0..<4) { index in
                                Text("\(minutes[index])").tag("\(minutes[index])")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 80)
                        .clipped()
                    }
                    .padding()
                    .background(Color.themeTextField)
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
                }
                
                Section {
                    Button(action: {
                        if selectedGame == nil || address.isEmpty || selectedHour.isEmpty || selectedMinute.isEmpty || isSelectedDate == false {
                            isError = 2
                            showAlert = true
                        } else {
                            let dateFormatter: DateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "yyyy-MM-dd"
                            var hour = String(selectedHour)
                            var minutes = String(selectedMinute)
                            if hour == "0" {
                                hour = "00"
                            }
                            if minutes == "0" {
                                minutes = "00"
                            }
                            let hours = hour + ":" + minutes
                            Task {
                                do {
                                    let result = await vm.createMatch(maxNumPlayer: numberOfPlayers, date: dateFormatter.string(from: selectedDate), hour: hours, place: address, game: selectedGame!)
                                    switch result {
                                    case .success:
                                        isError = 0
                                        isCreatingMatch = false
                                    case .failure(let err):
                                        switch err {
                                        case .createMatchError:
                                            isError = 1
                                            showAlert = true
                                        }
                                    }
                                }
                            }
                        }
                    }) {
                        Text("Crear partida")
                            .font(.headline)
                            .padding()
                            .frame(width: 200, height: 50)
                            .background(Color.green)
                            .cornerRadius(15.0)
                            .shadow(radius: 10.0, x: 20, y: 10)
                    }
                    .alert(isPresented: $showAlert) {
                        showAlertCreateGame()
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.clear.edgesIgnoringSafeArea(.all))
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(gradient: Gradient(colors: [.lightGreen, .darkGreen]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    isCreatingMatch = false
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Volver")
                    }
                }
            }
        }
        .onAppear {
            vm.getAllGames()
        }
    }
    
    private func searchAddress() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            guard error == nil else {
                print("Error buscando dirección:", error!.localizedDescription)
                return
            }
            
            if let location = placemarks?.first?.location {
                mapCoordinate = location.coordinate
                region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            }
        }
    }
    
    func showAlertCreateGame() -> Alert {
        var textoError = "Error al guardar partida"
        if isError == 2 {
            textoError = "Complete todos los campos para poder crear la partida"
        }
        return Alert(title: Text("Crear nueva partida"), message: Text(textoError), dismissButton: .default(Text("OK")))
    }
}

struct MapView: UIViewRepresentable {
    var coordinate: CLLocationCoordinate2D?
    @Binding var region: MKCoordinateRegion
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView()
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let coordinate = coordinate {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            uiView.removeAnnotations(uiView.annotations)
            uiView.addAnnotation(annotation)
            uiView.setRegion(region, animated: true)
        } else {
            uiView.removeAnnotations(uiView.annotations)
        }
    }
}

