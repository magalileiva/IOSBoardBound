//
//  CreatePublisherViewModel.swift
//  BoardBound
//
//  Created by Magali Leiva on 6/6/24.
//

import Foundation
import FirebaseAuth
import Alamofire

class CreatePublisherViewModel: ObservableObject{
    
    enum CreatePublisherError: Error{
        case createPublisherError
    }
    
    @Published var isBusy = false
    
    func createPublisher(name: String) async -> Result<Bool, CreatePublisherError> {
        isBusy = true
        
        do{
            // Llamar al API para guardar el nuevo editor
            try await Task.sleep(nanoseconds: 2000000000)
            try await savePublisherToAPI(name: name)
            isBusy = false
            return .success(true)
        }catch{
            isBusy = false
            return .failure(.createPublisherError)
        }
    }
    
    func savePublisherToAPI(name: String) async throws {
        let parameters: [String: Any] = [
            "name": name
        ]
                        
        guard let url = URL(string: "\(NetworkingProvider().urlBase)publisher") else {
            throw NSError(domain: "Invalid Response", code: 1, userInfo: nil)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let json = try JSONSerialization.data(withJSONObject: parameters)
        print(json)
        request.httpBody = json
        let (_, response) = try await URLSession.shared.data(for: request)
        
        let httpResponse = response as? HTTPURLResponse
        
        if httpResponse?.statusCode != 200 {
            throw NSError(domain: "Invalid Response", code: 1, userInfo: nil)
        }
    }
    
}
