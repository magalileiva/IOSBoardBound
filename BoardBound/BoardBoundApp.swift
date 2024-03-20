//
//  BoardBoundApp.swift
//  BoardBound
//
//  Created by Magali Leiva on 20/3/24.
//

import SwiftUI
import SwiftData
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct BoardBoundApp: App {
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var loginViewModel = LoginViewModel()
    @StateObject var signInViewModel = SignInViewModel()
    @StateObject var createGameViewModel = CreateGameViewModel()
    @StateObject var createPublisherVievModel = CreatePublisherViewModel()
    @StateObject var createMatchViewModel = CreateMatchViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                ApplicationSwitcher()
            }
            .navigationViewStyle(.stack)
            .environmentObject(loginViewModel)
            .environmentObject(signInViewModel)
            .environmentObject(createGameViewModel)
            .environmentObject(createPublisherVievModel)
            .environmentObject(createMatchViewModel)
        }
    }
}

struct ApplicationSwitcher: View {
    
    @EnvironmentObject var vm: LoginViewModel
    
    var body: some View {
        if (vm.isLoggedIn || UserDefaults.standard.bool(forKey: "isLogged")) {
                ContentView()
        } else {
            LoginView()
        }
    }
}
