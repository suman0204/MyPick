//
//  Item.swift
//  2ndRecap
//
//  Created by 홍수만 on 2023/09/08.
//

import Foundation

// MARK: - Items
struct Item: Codable {
    let lastBuildDate: String
    let total, start, display: Int
    let items: [ItemResult]
}

// MARK: - Item
struct ItemResult: Codable {
    let title: String
    let link: String
    let image: String
    let lprice, hprice, mallName, productID: String
    let productType, brand: String
    let maker: String
    let category1: String
    let category2: String
    let category3: String
    let category4: String
    
    var like: Bool = false
    
    var noTagTitle: String {
        return title.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
    }
    
    var decimalPrice: String {
        let numberFommater: NumberFormatter = NumberFormatter()
        numberFommater.numberStyle = .decimal
        let decimalPrice = Int(lprice)
        return numberFommater.string(for: decimalPrice) ?? "0"
    }
    
    enum CodingKeys: String, CodingKey {
        case title, link, image, lprice, hprice, mallName
        case productID = "productId"
        case productType, brand, maker, category1, category2, category3, category4
    }
}


