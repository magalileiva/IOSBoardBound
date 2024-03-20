//
//  ContentViewModel.swift
//  BoardBound
//
//  Created by Magali Leiva on 22/3/24.
//
import Foundation
import Alamofire

class GameViewModel: ObservableObject {
    
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
    
}
