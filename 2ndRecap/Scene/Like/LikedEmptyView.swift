//
//  LikedEmptyView.swift
//  2ndRecap
//
//  Created by 홍수만 on 2023/09/16.
//

import UIKit
import SnapKit

class LikedEmptyView: UIView {
    
    let isEmptyLabel = {
        let view = UILabel()
        view.textColor = Constants.BaseColor.text
        view.font = .boldSystemFont(ofSize: 17)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        addSubview(isEmptyLabel)
    }
    
    func setConstraints() {
        isEmptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

