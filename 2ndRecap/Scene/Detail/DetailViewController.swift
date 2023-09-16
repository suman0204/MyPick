//
//  DetailViewController.swift
//  2ndRecap
//
//  Created by 홍수만 on 2023/09/10.
//

import UIKit
import WebKit
import RealmSwift

class DetailViewController: BaseViewController {
    
    var tasks: Results<LikedTable>!
    
    var repository = LikedTableRepository()
    
    var itemDetailWebView: WKWebView = WKWebView()
    
    var navTitle: String?
    
    var productInfo: ItemResult?
//    var likedInfo: LikedTable?
    var productID: String?
    
    var viewType: ViewType?
    
    lazy var likeBarButton: UIBarButtonItem = {
        let view = UIBarButtonItem()
        view.target = self
        view.style = .plain
        view.image = UIImage(systemName: "heart")
        view.tintColor = .white
        view.action = #selector(likeBarButtonClicked)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasks = repository.fetch()
        
        guard let navTitle = navTitle else {
            print("No Title")
            return
        }

        print(navTitle)
        title = navTitle
        
//        setNavTitle()
        


//        UIBarButtonItemAppearance.setValue(<#T##value: Any?##Any?#>, forKey: <#T##String#>)
//        let likeButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(likeBarButtonClicked))
//        likeButton.tintColor = .white
        
        if (tasks.first(where: { $0.itemID == productID}) != nil) {
            print("잇어요")
            likeBarButton.image = UIImage(systemName: "heart.fill")
        } else {
            print("없어요")
            likeBarButton.image = UIImage(systemName: "heart")

        }
        
        navigationItem.rightBarButtonItem = likeBarButton
    }
    
    @objc func likeBarButtonClicked() {
        print("barbutton")
//        guard let productID = productID else {
//            return
//        }
        if likeBarButton.image == UIImage(systemName: "heart.fill") {
//            repository.deleteItem(id: productID)
            likeBarButton.image = UIImage(systemName: "heart")
        } else {
            likeBarButton.image = UIImage(systemName: "heart.fill")
            print("heart.fill")
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        guard let productID = productID else {
            return
        }
        
        if likeBarButton.image == UIImage(systemName: "heart") {
            repository.deleteItem(id: productID)
        } else {
            print("hello")
            if let productInfo = productInfo {
                if (tasks.first(where: {
                    $0.itemID == productInfo.productID
                }) == nil) {
                    let task = LikedTable(id: productInfo.productID, title: productInfo.title, mallName: productInfo.mallName, lprice: productInfo.lprice, imageURL: productInfo.image, likedDate: Date(), like: true)
                    
                    repository.createItem(task)
                } else {
                    print("dd")
                }
                
            }
            
        }
    }
    
    override func configureView() {
        
        title = "title"
        
        view.addSubview(itemDetailWebView)
        
        guard let productID = productID else {
            print("No productID")
            return
        }
        
//        let url = URL(string: "https://msearch.shopping.naver.com/product/\(productID)")
        let url = URL.makeDetailURLEndPoint(endPoint: productID)
        let request = URLRequest(url: url)
        itemDetailWebView.load(request)
        
        let navAppearance = UINavigationBarAppearance()
        navAppearance.backgroundColor = .black
        navAppearance.titleTextAttributes =  [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = navAppearance
      
        let tabAppearance = UITabBarAppearance()
        tabAppearance.backgroundColor = .black
        tabBarController?.tabBar.standardAppearance = tabAppearance
        
//        if (tasks.first(where: { $0.itemID == productID}) != nil) {
//            print("잇어요")
//            cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//        } else {
//            print("없어요")
//            cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
//
//        }
        
    }
    
    override func setConstraints() {
        itemDetailWebView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension DetailViewController {
    
//    func setNavTitle() {
//        switch viewType {
//        case .searchView:
//            title = productInfo?.noTagTitle
//        case.likedView:
//            title = likedInfo?.itemTitle
//        case .none:
//            title = "Error"
//        }
//    }
    
}
