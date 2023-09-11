//
//  LikedTable.swift
//  2ndRecap
//
//  Created by 홍수만 on 2023/09/11.
//

import Foundation
import RealmSwift

class LikedTable: Object {
    
    @Persisted(primaryKey: true) var itemID: String
    @Persisted var itemTitle: String
    @Persisted var itemMallName: String
    @Persisted var itemLprice: String
    @Persisted var itemImageURL: String
    @Persisted var likedDate: Date
    @Persisted var detailURL: String
    @Persisted var like: Bool
    
    convenience init(id: String, title: String, mallName: String, lprice: String, imageURL: String, likedDate: Date, like: Bool) {
        self.init()
        
        self.itemID = id
        self.itemTitle = title
        self.itemMallName = mallName
        self.itemLprice = lprice
        self.itemImageURL = imageURL
        self.likedDate = likedDate
        self.detailURL = ""
        self.like = like
    }
}
