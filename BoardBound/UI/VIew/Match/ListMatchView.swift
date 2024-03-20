import SwiftUI

struct ListMatchView: View {
    @State private var isCreatingMatch = false
    @ObservedObject private var viewModel = MatchViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    Text("Partidas")
                        .font(.title)
                        .padding()
                    Spacer()
                    Button(action: {
                        isCreatingMatch = true
                    }) {
                        Image(systemName: "waveform.badge.plus")
                            .font(.title3)
                            .padding()
                            .foregroundColor(.black)
                            .background(Color.clear)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .navigationDestination(isPresented: $isCreatingMatch) {
                        CreateMatchView(isCreatingMatch: $isCreatingMatch)
                            .toolbar(.hidden, for: .tabBar)
                    }
                }
                .background(Color.clear)
                
                List(viewModel.matchs) { match in
                    NavigationLink(destination: MatchDetailView(match: match)) {
                        MatchRowView(match: match)
                    }
                    .listRowBackground(Color.clear)
                }
                .listStyle(PlainListStyle())
                .background(Color.clear)

                .onAppear {
                    viewModel.getAllMatchs()
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [.lightGreen, .darkGreen]),startPoint: .top,endPoint: .bottom).edgesIgnoringSafeArea(.all))
            .onAppear {
                UITabBar.appearance().isHidden = false
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

struct MatchRowView: View {
    let match: Match

    var body: some View {
        VStack(alignment: .leading) {
            Text(match.boardGame.name)
                .font(.headline)
            
            Text("\(match.date) a las \(match.hour)")
                .font(.subheadline)
            Text("Lugar: \(match.place)")
                .font(.subheadline)
            Text("Estado: \(match.status)")
                .font(.subheadline)
        }
        .background(Color.clear)
    }
}
