//
//  ViewController+Extension.swift
//  2ndRecap
//
//  Created by 홍수만 on 2023/09/16.
//

import UIKit

extension BaseViewController {
    func scrollToTop(collectionView: UICollectionView) {
        let desiredOffset = CGPoint(x: 0, y: -collectionView.contentInset.top)
        collectionView.setContentOffset(desiredOffset, animated: true)
    }
    
    func requestInsertWord() {
        let alert = UIAlertController(title: "검색어를 입력하세요", message: "검색어 입력 후 검색해주세요!", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "확인", style: .default)
        
        alert.addAction(ok)
        
        present(alert, animated: true)

    }
    
    func noResultAlert() {
        let alert = UIAlertController(title: "검색 결과가 없습니다", message: "다른 검색어를 입력해주세요", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "확인", style: .default)
        
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
}
