//
//  ShoppingAPIManager.swift
//  2ndRecap
//
//  Created by 홍수만 on 2023/09/10.
//

import Foundation
import Alamofire

class ShoppingAPIManager {
    
    private init() { }
    
    static let shared = ShoppingAPIManager()
    
    func callRequest(query: String, start: Int, sort: SortType, success: @escaping (Item) -> Void, failure: @escaping () -> Void) {
        let baseURL = "https://openapi.naver.com/v1/search/shop.json?query="
        let encodingQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let url = baseURL + encodingQuery + "&display=30" + "&start=\(start)" + "&sort=\(sort)"
        
        let header = APIKey.header
        
        
        
        AF.request(url, method: .get, headers: header).validate(statusCode: 200...500).responseDecodable(of: Item.self) { response in
            print("url: \(url)")
            switch response.result {
            case .success(let value):
                print(value)
                success(value)
            case .failure(let error):
                print(error)
                failure()
            }
        }
    }
}
