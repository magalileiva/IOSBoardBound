//
//  ProfileView.swift
//  BoardBound
//
//  Created by Magali Leiva on 7/4/24.
//

import SwiftUI

struct MatchView: View {
    
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor.black
    }
    
    @State private var selectedIndex: Int = 1
    
    var body: some View {
        
        VStack{
            TabView(selection: $selectedIndex) {
                        ListMatchView()
                        .tabItem {
                            Text("Partidas")
                            Image("partidas")
                                .renderingMode(.template)
                            
                        }
                        .tag(0)
                        
                        MyMatchView()
                        .tabItem {
                            Text("Mis partidas")
                            Image("mispartidas")
                                .renderingMode(.template)
                        }
                        .tag(1)
            }
            .accentColor(.white)
        }
    }
}


