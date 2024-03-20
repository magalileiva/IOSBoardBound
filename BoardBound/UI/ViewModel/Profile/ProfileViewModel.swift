//
//  ProfileViewModel.swift
//  BoardBound
//
//  Created by Magali Leiva on 23/6/24.
//

import Foundation
import Alamofire

class ProfileViewModel: ObservableObject {
    
    @Published var info: InfoPlayer? = nil
    
    func getinfoUser() {
        let url = "\(NetworkingProvider().urlBase)user/\(UserDefaults.standard.integer(forKey: "userId"))/matches"
        AF.request(url)
            .responseDecodable(of: InfoPlayer.self) { response in
                switch response.result {
                case .success(let info):
                    self.info = info
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
    
}
