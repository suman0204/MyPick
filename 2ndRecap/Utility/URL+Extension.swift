//
//  URL+Extension.swift
//  2ndRecap
//
//  Created by 홍수만 on 2023/09/10.
//

import Foundation

extension URL {
    
    static let detailBaseURL: String = "https://msearch.shopping.naver.com/product/"
    
    static func makeDetailURLEndPoint(endPoint: String) -> URL {
        return URL(string: detailBaseURL + endPoint) ?? URL(string: "")!
    }
    
}
