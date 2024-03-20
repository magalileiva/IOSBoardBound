//
//  CreateMatchViewModel.swift
//  BoardBound
//
//  Created by Magali Leiva on 13/6/24.
//

import Foundation
import Alamofire

class CreateMatchViewModel: ObservableObject {
    
    enum CreateMatchError: Error{
        case createMatchError
    }
    
    @Published var isBusy = false
    @Published var games: [BoardGame] = []

    func getAllGames() {
        let url = "\(NetworkingProvider().urlBase)boardGame"
        AF.request(url)
        .responseDecodable(of: [BoardGame].self) { response in
            switch response.result {
            case .success(let games):
                self.games = games
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func createMatch(maxNumPlayer: Int, date: String, hour: String, place: String, game: BoardGame) async -> Result<Bool, CreateMatchError> {
        isBusy = true
        
        do{
            // Llamar al API para guardar el nuevo juego
            try await saveMatchToAPI(maxNumPlayer: maxNumPlayer, date: date, hour: hour, place: place, gameId: game.id)
            isBusy = false
            return .success(true)
        }catch{
            isBusy = false
            return .failure(.createMatchError)
        }
    }
    
    func saveMatchToAPI(maxNumPlayer: Int, date: String, hour: String, place: String, gameId: Int) async throws {
    
        
        let parameters: [String: Any] = [
            "minNumPlayer": 2,
            "maxNumPlayer": maxNumPlayer,
            "date": date,
            "hour": hour,
            "place": place,
            "status": "open",
            "boardGame": [
                "id": gameId
            ],
            "players": [
                ["id": UserDefaults.standard.integer(forKey: "userId")]
            ]
        ]
                        
        guard let url = URL(string: "\(NetworkingProvider().urlBase)game") else {
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
