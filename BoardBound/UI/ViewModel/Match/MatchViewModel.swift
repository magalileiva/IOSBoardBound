//
//  MatchViewModel.swift
//  BoardBound
//
//  Created by Magali Leiva on 19/6/24.
//

import Foundation
import Alamofire

class MatchViewModel: ObservableObject {
    
    enum CreateMatchError: Error{
        case createMatchError
    }
    
    @Published var isBusy = false
    @Published var matchs: [Match] = []
    
    func getAllMatchs() {
        let url = "\(NetworkingProvider().urlBase)game"
        AF.request(url)
        .responseDecodable(of: [Match].self) { response in
            switch response.result {
            case .success(let matchs):
                self.matchs = matchs
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getAllMatchsByPlayer() {
        let url = "\(NetworkingProvider().urlBase)game/player/\(UserDefaults.standard.integer(forKey: "userId"))"
        AF.request(url)
        .responseDecodable(of: [Match].self) { response in
            switch response.result {
            case .success(let matchs):
                self.matchs = matchs
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func addPlayer(gameId: Int) async -> Result<Bool, CreateMatchError> {
        isBusy = true
        
        do{
            try await addPlayerToAPI(gameId: gameId)
            isBusy = false
            return .success(true)
        }catch{
            isBusy = false
            return .failure(.createMatchError)
        }
    }
    
    func addPlayerToAPI(gameId: Int) async throws {
                        
        guard let url = URL(string: "\(NetworkingProvider().urlBase)game/\(gameId)/players/\(UserDefaults.standard.integer(forKey: "userId"))") else {
            throw NSError(domain: "Invalid Response", code: 1, userInfo: nil)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let (_, response) = try await URLSession.shared.data(for: request)
        
        let httpResponse = response as? HTTPURLResponse
        
        if httpResponse?.statusCode != 200 {
            throw NSError(domain: "Invalid Response", code: 1, userInfo: nil)
        }
    }
    
    func deletePlayer(gameId: Int, userId: Int) async -> Result<Bool, CreateMatchError> {
        isBusy = true
        
        do{
            try await deletePlayerToAPI(gameId: gameId, userId: userId)
            isBusy = false
            return .success(true)
        }catch{
            isBusy = false
            return .failure(.createMatchError)
        }
    }
    
    func deletePlayerToAPI(gameId: Int, userId: Int) async throws {
                        
        guard let url = URL(string: "\(NetworkingProvider().urlBase)game/\(gameId)/players/\(userId)") else {
            throw NSError(domain: "Invalid Response", code: 1, userInfo: nil)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        let (_, response) = try await URLSession.shared.data(for: request)
        
        let httpResponse = response as? HTTPURLResponse
        
        if httpResponse?.statusCode != 200 {
            throw NSError(domain: "Invalid Response", code: 1, userInfo: nil)
        }
    }
    
    func addComment(gameId: Int,comment: Comment) async -> Result<Bool, CreateMatchError> {
        isBusy = true
        
        do{
            try await addCommentToAPI(gameId: gameId,comment: comment)
            isBusy = false
            return .success(true)
        }catch{
            isBusy = false
            return .failure(.createMatchError)
        }
    }
    
    func addCommentToAPI(gameId: Int, comment: Comment) async throws {
        
        let parameters: [String: Any] = [
            "text": comment.text,
            "game": [
                "id": gameId
            ],
            "user": [
                "id": comment.user.id
            ]
        ]
                        
        guard let url = URL(string: "\(NetworkingProvider().urlBase)game/\(gameId)/comments") else {
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
