//
//  WhiteButton.swift
//  2ndRecap
//
//  Created by 홍수만 on 2023/09/11.
//

import UIKit

class WhiteButton: UIButton{
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
        layer.borderColor = Constants.BaseColor.border
        setTitleColor(Constants.BaseColor.background, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 14)
        backgroundColor = .white
    }
}
