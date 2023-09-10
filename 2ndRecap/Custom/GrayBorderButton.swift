//
//  GrayBorderButton.swift
//  2ndRecap
//
//  Created by 홍수만 on 2023/09/09.
//

import UIKit

class GrayBorderButton: UIButton {
    override init(frame: CGRect) {
        super .init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        layer.cornerRadius = Constants.Design.cornerRadius
        layer.borderWidth = Constants.Design.borderWidth
        layer.borderColor = Constants.BaseColor.placeholder.cgColor
        setTitleColor(Constants.BaseColor.placeholder, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 14)
    }
}
