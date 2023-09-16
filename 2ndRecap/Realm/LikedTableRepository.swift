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
    
    func filter(itemID: String) -> Bool {
        let result = realm.objects(LikedTable.self).where({
            $0.itemID == itemID
        })
        
        if !result.isEmpty {
            return true
        } else {
            return false
        }
        
//        let result = realm.objects(LikedTable.self).where {
//            //1. 대소문자 구별 없음 - caseInsensitive
////            $0.diaryTitle.contains("제목", options: .caseInsensitive) //title에 제목이 포함된 row만
//
//            //2. Bool
////            $0.diaryLike == true
//
//            //3. 사진이 있는 데이터만 불러오기 (diaryPhoto의 nil 여부 판단)
////            $0.itemID != nil
////            $0.diaryPhoto.isEmpty // 사용 불가
////            $0.itemID.contains(itemID, op)
//            $0.itemID == itemID
//        }
//        return result
    }
    
    func fetchFilter(title: String) -> Results<LikedTable> {
//
//        let result = realm.objects(LikedTable.self).where {
//            $0.itemTitle == title
//        }
        
        let result = realm.objects(LikedTable.self).where {
            $0.itemTitle.contains(title, options: .caseInsensitive)
        }
        return result
    }
}
