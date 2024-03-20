//
//  LoginViewModel.swift
//  BoardBound
//
//  Created by Magali Leiva on 7/4/24.
//

import Foundation
import FirebaseAuth
import Alamofire

enum UserStateError: Error{
    case signInError, signOutError
}

@MainActor
class LoginViewModel: ObservableObject{
    
    @Published var isLoggedIn = false
    @Published var isBusy = false
    var user: User? = nil
    
    func logIn(email: String, password: String) async -> Result<Bool, UserStateError> {
        isBusy = true
        
        do{
            try await Auth.auth().signIn(withEmail: email, password: password)
            
            fetchUser(email: email.lowercased())
            
            return .success(true)
        }catch{
            isBusy = false
            return .failure(.signInError)
        }
    }
    
    func fetchUser(email: String) {
        let url = "\(NetworkingProvider().urlBase)user/email?email=\(email)"
        AF.request(url)
            .responseDecodable(of: User.self) { response in
                switch response.result {
                case .success(let user):
                    self.user = user
                    UserDefaults.standard.set(true, forKey: "isLogged")
                    UserDefaults.standard.set(email, forKey: "email")
                    UserDefaults.standard.set(self.user?.username, forKey: "username")
                    UserDefaults.standard.set(self.user?.id, forKey: "userId")
                    
                    self.isLoggedIn = true
                    self.isBusy = false
                case .failure(let error):
                    print(error.localizedDescription)
                    self.isLoggedIn = false
                    self.isBusy = false
                }
            }
    }
    
    func logOut() async -> Result<Bool, UserStateError> {
        isBusy = true
        do{
            try Auth.auth().signOut()
            isLoggedIn = false
            UserDefaults.standard.set(false, forKey: "isLogged")
            UserDefaults.standard.set("", forKey: "email")
            UserDefaults.standard.set("", forKey: "username")
            isBusy = false
            return .success(true)
            
        }catch{
            isBusy = false
            return .failure(.signOutError)
        }
    }
    
}
