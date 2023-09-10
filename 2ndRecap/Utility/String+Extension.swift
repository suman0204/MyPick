//
//  String+Extension.swift
//  2ndRecap
//
//  Created by 홍수만 on 2023/09/11.
//

import Foundation

extension String {
    func removeTags() -> String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
    }
    
}
