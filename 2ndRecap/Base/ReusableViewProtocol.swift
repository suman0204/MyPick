//
//  ReusableViewProtocol.swift
//  2ndRecap
//
//  Created by 홍수만 on 2023/09/09.
//

import UIKit

protocol ReusableViewProtocol: AnyObject {
    static var reuseIdentifier: String { get }
}

extension UICollectionViewCell: ReusableViewProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
