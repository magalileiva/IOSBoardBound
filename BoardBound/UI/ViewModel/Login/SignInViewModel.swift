//
//  SignInViewModel.swift
//  BoardBound
//
//  Created by Magali Leiva on 12/5/24.
//

import Foundation
import FirebaseAuth
import Alamofire

class SignInViewModel: ObservableObject{
    
    enum UserStateError: Error{
        case signInError
    }
    
    @Published var isBusy = false
    
    func signIn(username: String, email: String, password: String) async -> Result<Bool, UserStateError> {
        isBusy = true
        
        do{
            if username == "" {
                    throw NSError()
            }
            try await Auth.auth().createUser(withEmail: email, password: password)
            
            // Llamar al API para guardar el nuevo usuario
            try await saveUserToAPI(username: username, email: email.lowercased())
            
            isBusy = false
            return .success(true)
        }catch{
            isBusy = false
            return .failure(.signInError)
        }
    }
    
    func saveUserToAPI(username: String, email: String) async throws {
        let parameters: [String: Any] = [
            "username": username,
            "email": email
        ]
                        
        guard let url = URL(string: "\(NetworkingProvider().urlBase)user") else {
            throw NSError(domain: "Invalid Response", code: 1, userInfo: nil)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let json = try JSONSerialization.data(withJSONObject: parameters)
        
        request.httpBody = json
        let (_, response) = try await URLSession.shared.data(for: request)
        
        let httpResponse = response as? HTTPURLResponse
        
        if httpResponse?.statusCode != 200 {
            throw NSError(domain: "Invalid Response", code: 1, userInfo: nil)
        }
    }








    
    
    
}
