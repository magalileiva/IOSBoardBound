import SwiftUI
import MapKit

struct MatchDetailView: View {
    
    let match: Match
        
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var viewModel = MatchViewModel()
    @State private var newComment = ""
    
    var body: some View {
        VStack(alignment: .center) {
            
            Text("Detalles de partida")
                .font(.title)
                .padding()
                .multilineTextAlignment(.center)
            
            if !userInMatch(players: match.players) {
                Button(action: {
                    Task {
                        do {
                            await joinMatch()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }) {
                    Text("Unirme")
                        .font(.headline)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.green)
                        .cornerRadius(15.0)
                        .shadow(radius: 10.0, x: 20, y: 10)
                }
            }
            
            ScrollView {
                AsyncImage(url: URL(string: match.boardGame.urlImage)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 120, height: 120)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 120)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 120)
                            .foregroundColor(.gray)
                    @unknown default:
                        Image(systemName: "exclamationmark.triangle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 150)
                            .foregroundColor(.red)
                    }
                }
                .padding()
                
                HStack {
                    Text("Fecha: \(match.date)")
                        .font(.headline)
                        .padding()
                    
                    Text("Hora: \(match.hour)")
                        .font(.headline)
                        .padding()
                }
                
                Text("Lugar: \(match.place)")
                    .font(.headline)
                    .padding()
                
                MapViewDetail(locationName: match.place)
                    .frame(height: 200)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                
                Section(header: Text("Lista de jugadores").font(.headline)) {
                    ForEach(match.players) { player in
                        HStack {
                            Text(player.username)
                            Spacer()
                            if (isCreator() && player.id != UserDefaults.standard.integer(forKey: "userId")){
                                Button(action: {
                                    Task {
                                        do {
                                            await removePlayer(player: player)
                                            presentationMode.wrappedValue.dismiss()
                                        }
                                    }
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                }
                .padding()
                
                Section(header: Text("Comentarios").font(.headline)) {
                    ForEach(match.comments) { comment in
                        CommentView(comment: comment)
                    }
                }
                .padding()
                
                if userInMatch(players: match.players) {
                    VStack {
                        Text("Añadir comentario").font(.headline)
                        TextEditor(text: $newComment)
                            .frame(height: 100)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                            .padding()
                        Button(action: {
                            Task {
                                do {
                                    await addComment()
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }) {
                            Text("Añadir")
                                .font(.headline)
                                .padding()
                                .frame(width: 200, height: 50)
                                .background(Color.green)
                                .cornerRadius(15.0)
                                .shadow(radius: 10.0, x: 20, y: 10)
                        }
                    }
                    .padding()
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(gradient: Gradient(colors: [.lightGreen, .darkGreen]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Volver")
                    }
                }
            }
        }
    }
    
    struct CommentView: View {
        let comment: Comment
        
        var body: some View {
            HStack(alignment: .top) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.green)
                
                VStack(alignment: .leading) {
                    Text(comment.user.username)
                        .font(.headline)
                    Text(comment.text)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.top, 1)
                }
                .padding(.leading, 5)
                
                Spacer()
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 10)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)
            .shadow(radius: 3)
            .padding(.horizontal)
        }
    }
    
    func userInMatch(players: [User]) -> Bool {
        let userId = UserDefaults.standard.integer(forKey: "userId")
        return players.contains { $0.id == userId }
    }
    
    func isCreator() -> Bool {
        let userId = UserDefaults.standard.integer(forKey: "userId")
        return match.creatorPlayer.id == userId
    }
    
    func joinMatch() async {
        _ = await viewModel.addPlayer(gameId: match.id)
    }
    
    func removePlayer(player: User) async {
        _ = await viewModel.deletePlayer(gameId: match.id, userId: player.id)
    }
    
    func addComment() async {
        guard let email = UserDefaults.standard.string(forKey: "email") else { return }
        guard let userName = UserDefaults.standard.string(forKey: "username") else { return }
        let id = UserDefaults.standard.integer(forKey: "userId")
        let user = User(id: id, username: userName, email: email)
        let comment = Comment(id: nil, text: newComment, user: user)
    
        _ = await viewModel.addComment(gameId: match.id, comment: comment)
        
    }
}

struct MapViewDetail: UIViewRepresentable {
    let locationName: String
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.isUserInteractionEnabled = false // Deshabilitar la interacción del usuario
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Geocode the location name to get coordinates
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationName) { placemarks, error in
            if let placemark = placemarks?.first {
                let coordinates = placemark.location?.coordinate
                if let coordinates = coordinates {
                    // Add annotation for the location
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinates
                    annotation.title = locationName
                    uiView.addAnnotation(annotation)
                    
                    // Zoom to the location
                    let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
                    uiView.setRegion(region, animated: true)
                }
            }
        }
    }
}

