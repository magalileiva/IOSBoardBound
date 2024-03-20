//
//  ContentView.swift
//  SwiftUISideMenuDemo
//
//  Created by Rupesh Chaudhari on 24/04/22.
//

import SwiftUI

struct ContentView: View {
    @State private var isSidebarVisible = false
    @State private var currentScreen: Screen? = Screen.Partidas
    
    var body: some View {
        ZStack {
            switch currentScreen {
            case .Juegos:
                GameView()
            case .Partidas:
                MatchView()
            case .Perfil:
                ProfileView()
            case .none, .Logout:
                EmptyView()
            }
                
            SideMenu(isSidebarVisible: $isSidebarVisible, currentScreen: $currentScreen)
            
            }
    }
}
