//
//  SearchCollectionViewCell.swift
//  2ndRecap
//
//  Created by 홍수만 on 2023/09/08.
//

import UIKit
import Kingfisher

class SearchCollectionViewCell: BaseCollectionViewCell {
    
    var data: ItemResult?
    
    let imageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = Constants.Design.cornerRadius
        view.layer.masksToBounds = true
//        view.layer.borderWidth = Constants.Design.borderWidth
//        view.layer.borderColor
        view.backgroundColor = .lightGray
        return view
    }()
    
    let mallNameLabel = {
        let view = UILabel()
        view.textColor = Constants.BaseColor.placeholder
        view.font = .systemFont(ofSize: 12)
        
        view.text = "[dfadsfa]"
        
        return view
    }()
    
    let titleLabel = {
        let view = UILabel()
        view.textColor = .systemGray5
        view.font = .systemFont(ofSize: 14)
        view.numberOfLines = 2
        
        view.text = "[dfadsfa]dasfasdfasdfasdfafadasfasdfasdfasdfafa"

        return view
    }()
    
    let priceLabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = .boldSystemFont(ofSize: 16)
        
        view.text = "2342342343"

        return view
    }()
    
    let likeButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "heart"), for: .normal)
        view.tintColor = .black
        view.backgroundColor = .white
//        view.layer.borderWidth = Constants.Design.borderWidth
//        view.layer.cornerRadius = view.bounds.width / 2
//        view.layer.masksToBounds = true
//        view.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        return view
    }()
    
    @objc func likeButtonClicked() {
        print("like")
    }
    
    override func layoutSubviews() { //mainview를 따로 만들어야하나?...
        super.layoutSubviews()
        likeButton.layer.cornerRadius = likeButton.bounds.width / 2
    }
    

    
    override func configureCell() {
        [imageView, mallNameLabel, titleLabel, priceLabel, likeButton].forEach {
            contentView.addSubview($0)
        }
        
        likeButton.becomeFirstResponder()
        
    }
    
    override func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.size.equalTo(contentView.snp.width)
        }
        
        mallNameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview().inset(5)
//            make.height.equalTo(10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mallNameLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview().inset(5)
//            make.height.equalTo(20)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview().inset(5)

//            make.height.equalTo(10)
        }
        
        likeButton.snp.makeConstraints { make in
            make.size.equalTo(imageView.snp.width).multipliedBy(0.2)
            make.trailing.equalTo(imageView.snp.trailing).offset(-8)
            make.bottom.equalTo(imageView.snp.bottom).offset(-8)
            
        }
        
        
    }
}
