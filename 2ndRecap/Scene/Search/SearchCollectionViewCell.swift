//
//  SearchCollectionViewCell.swift
//  2ndRecap
//
//  Created by 홍수만 on 2023/09/08.
//

import UIKit
import Kingfisher
import RealmSwift

class SearchCollectionViewCell: BaseCollectionViewCell {
    
    var data: ItemResult?
    
    var like: Bool = false {
        didSet {
            self.configureCell()
        }
    }
    
    var completionHandler: ((Bool) -> ())?
    
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
        return view
    }()


    
    override func layoutSubviews() { //mainview를 따로 만들어야하나?...
        super.layoutSubviews()
        likeButton.layer.cornerRadius = likeButton.bounds.width / 2
    }
    
    func inputAPIData(data: ItemResult) {
        imageView.kf.setImage(with: URL(string: data.image))
        mallNameLabel.text = "[\(data.mallName)]"
        titleLabel.text = data.title.removeTags()

        priceLabel.text = decimalFormat(price: Int(data.lprice) ?? 0)
        
        like = data.like
        
        if !like {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }

    func inputRealmData(data: LikedTable) {
        imageView.kf.setImage(with: URL(string: data.itemImageURL))
        mallNameLabel.text = "[\(data.itemMallName)]"
        titleLabel.text = data.itemTitle.removeTags()

        priceLabel.text = decimalFormat(price: Int(data.itemLprice) ?? 0)
        
        like = data.like
        
        if !like {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
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
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mallNameLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview().inset(5)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview().inset(5)
        }
        
        likeButton.snp.makeConstraints { make in
            make.size.equalTo(imageView.snp.width).multipliedBy(0.2)
            make.trailing.equalTo(imageView.snp.trailing).offset(-8)
            make.bottom.equalTo(imageView.snp.bottom).offset(-8)
            
        }
        
        
    }
}

extension SearchCollectionViewCell {
    private func decimalFormat(price: Int) -> String? {
        let numberFommater: NumberFormatter = NumberFormatter()
        numberFommater.numberStyle = .decimal
        return numberFommater.string(for: price)
    }
}
