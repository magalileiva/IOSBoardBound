//
//  NetworkingProvider.swift
//  BoardBound
//
//  Created by Magali Leiva on 20/3/24.
//

import Foundation
import Alamofire

final class NetworkingProvider {
    
    static let shared = NetworkingProvider()
    
    public let urlBase = "https://boardbound-production.up.railway.app/api/v1/boardBound/"
    public let statusOk = 200...299
    
}
