//
//  MatchsView.swift
//  BoardBound
//
//  Created by Magali Leiva on 12/6/24.
//

import SwiftUI

struct MyMatchView: View {
    
    @State var isCreatingMatch = false
    @ObservedObject var viewModel = MatchViewModel()
    
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    Spacer()
                    Text("Mis Partidas")
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
                    }.navigationDestination(isPresented: $isCreatingMatch) {
                        CreateMatchView(isCreatingMatch: $isCreatingMatch)
                            .toolbar(.hidden, for: .tabBar)
                    }
                }
                List(viewModel.matchs) { match in
                    NavigationLink(destination: MatchDetailView(match: match)) {
                        MatchRowView(match: match)
                    }
                    .listRowBackground(Color.clear)
                }
                .listStyle(PlainListStyle())
                .background(Color.clear)
                .onAppear {
                    viewModel.getAllMatchsByPlayer()
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [.lightGreen, .darkGreen]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
            .onAppear {
                // Asegurarse de que la TabBar sea visible al volver a HomeView
                UITabBar.appearance().isHidden = false
            }
        }
    }
}
