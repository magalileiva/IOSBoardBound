import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel = GameViewModel()
    @State var isCreatingGame = false
    @State private var searchText = ""
    @State private var isSearchBarVisible = false
    
    var body: some View {
        NavigationStack {
            VStack {

                HStack {
                    Spacer()
                    Text("Juegos")
                        .font(.largeTitle)
                        .padding()
                    Button(action: {
                        isSearchBarVisible.toggle()
                    }) {
                        Image(systemName: "waveform.badge.magnifyingglass")
                            .font(.title3)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.clear)
                            .shadow(radius: 5)
                    }
                    
                    Button(action: {
                        isCreatingGame = true
                    }) {
                        Image(systemName: "waveform.badge.plus")
                            .font(.title3)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.clear)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }.navigationDestination(isPresented: $isCreatingGame) {
                        CreateGameView(isCreatingGame: $isCreatingGame)
                    }
                }
                    
                if isSearchBarVisible {
                    SearchBar(text: $searchText)
                        .padding()
                }
                    
                ScrollView {
                    Color.clear.frame(height: 0)
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                        ForEach(viewModel.games) { game in
                            NavigationLink(destination: BoardGameDetailView(game: game)) {
                                BoardGameView(game: game)
                            }
                        }
                    }
                    .padding()
                }
                .background(Color.clear)
                .onAppear(perform: viewModel.getAllGames)
                
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
            .background(LinearGradient(gradient: Gradient(colors: [.lightGreen, .darkGreen]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
        }
    }
}

struct BoardGameView: View {
    let game: BoardGame
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: game.urlImage)) { phase in
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
            
            Text(game.name)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(1)
        }
        .cornerRadius(15)
        .shadow(radius: 5)
        .background(Color.clear)
    }
}

struct BoardGameDetailView: View {
    let game: BoardGame
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: game.urlImage)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 200, height: 200)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .foregroundColor(.gray)
                @unknown default:
                    Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .foregroundColor(.red)
                }
            }
            
            Text(game.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            
            Text("Editor: \(game.publisher.name)")
                .font(.subheadline)
                .padding(.top, 1)
            
            Text("Jugadores: \(game.playerNumber)")
                .font(.subheadline)
                .padding(.top, 1)
            
            Text("Duración: \(game.duration) minutos")
                .font(.subheadline)
                .padding(.top, 1)
            
            Text("Edad sugerida: \(game.suggestedAge)+")
                .font(.subheadline)
                .padding(.top, 1)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(gradient: Gradient(colors: [.lightGreen, .darkGreen]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding()
                .background(Color.themeTextField)
                .cornerRadius(20.0)
                .shadow(radius: 10.0, x: 20, y: 10)
            
            Button(action: {
                text = ""
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
                    .padding(.trailing, 10)
            }
        }
    }
}

