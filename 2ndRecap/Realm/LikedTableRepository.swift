//
//  LikedTableRepository.swift
//  2ndRecap
//
//  Created by 홍수만 on 2023/09/11.
//

import Foundation
import RealmSwift

class LikedTableRepository {
    
    private let realm = try! Realm()
    
    func fetch() ->Results<LikedTable> {
        let data = realm.objects(LikedTable.self).sorted(byKeyPath: "likedDate", ascending: false)
        return data
    }
    
    func createItem(_ item: LikedTable) {
        
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print(error)
        }
    }
    
    func deleteItem(id: String) {
        let deletItem = realm.objects(LikedTable.self).where {
            $0.itemID == id
        }
        
        do {
            try realm.write {
                realm.delete(deletItem)
            }
        } catch {
            print(error)
        }
    }
}
