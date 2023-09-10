//
//  SortType.swift
//  2ndRecap
//
//  Created by 홍수만 on 2023/09/09.
//

import Foundation

enum SortType: CaseIterable {
    case sim
    case date
    case asc
    case dsc
    
    var typeName: String {
        switch self {
        case .sim:
            return "정확도"
        case .date:
            return "날짜순"
        case .asc:
            return "가격낮은순"
        case .dsc:
            return "가격높은순"
        }
    }
    

}
