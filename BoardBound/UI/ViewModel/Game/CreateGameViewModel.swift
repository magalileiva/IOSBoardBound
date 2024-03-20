//
//  CreateGameViewModel.swift
//  BoardBound
//
//  Created by Magali Leiva on 24/5/24.
//

import Foundation
import FirebaseAuth
import Alamofire

class CreateGameViewModel: ObservableObject{
    
    enum CreateGameError: Error{
        case createGameError
    }
    
    @Published var isBusy = false
    @Published var publishers: [BoardGamePublisher] = []
        
    func fetchPublishers() {
        let url = "\(NetworkingProvider().urlBase)publisher"
        AF.request(url)
            .responseDecodable(of: [BoardGamePublisher].self) { response in
                switch response.result {
                case .success(let publishers):
                    self.publishers = publishers
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
    
    func createGame(name: String, playerNumber: String, duration: String, suggestedAge: String, urlImage: String, difficulty: String, publisher: BoardGamePublisher) async -> Result<Bool, CreateGameError> {
        isBusy = true
        
        do{
            // Llamar al API para guardar el nuevo juego
            try await saveGameToAPI(name: name, playerNumber: playerNumber, duration: duration, suggestedAge: suggestedAge, urlImage: urlImage, difficulty: difficulty, publisherId: publisher.id)
            isBusy = false
            return .success(true)
        }catch{
            isBusy = false
            return .failure(.createGameError)
        }
    }
    
    func saveGameToAPI(name: String, playerNumber: String, duration: String, suggestedAge: String, urlImage: String, difficulty: String, publisherId: Int) async throws {
        let parameters: [String: Any] = [
            "name": name,
            "playerNumber": playerNumber,
            "duration": duration,
            "suggestedAge": suggestedAge,
            "urlImage": urlImage,
            "difficulty": difficulty,
            "publisher": [
                "id": publisherId
            ]
        ]
                        
        guard let url = URL(string: "\(NetworkingProvider().urlBase)boardGame") else {
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
