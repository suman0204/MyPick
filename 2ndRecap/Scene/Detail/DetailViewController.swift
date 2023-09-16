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
    
    private var tasks: Results<LikedTable>!
    
    private var repository = LikedTableRepository()
    
    private var itemDetailWebView: WKWebView = WKWebView()
    
    var navTitle: String?
    
    var productInfo: ItemResult?
//    var likedInfo: LikedTable?
    var productID: String?
    
//    var viewType: ViewType?
    
    private let bottomToolbar = {
        let view = UIToolbar()
        view.tintColor = .black
        view.barStyle = .default
        return view
    }()
    
    private lazy var backBarButton: UIBarButtonItem = {
        let view = UIBarButtonItem()
        view.target = self
        view.style = .plain
        view.action = #selector(goBackButtonClicked)
        view.tintColor = .black
        view.image = UIImage(systemName: "chevron.backward")
        return view
    }()
    
    private lazy var forwardBarButton: UIBarButtonItem = {
        let view = UIBarButtonItem()
        view.target = self
        view.style = .plain
        view.action = #selector(goForwardButtonClicked)
        view.tintColor = .black
        view.image = UIImage(systemName: "chevron.forward")
        return view
    }()
    
    private lazy var reloadBarButton: UIBarButtonItem = {
        let view = UIBarButtonItem()
        view.target = self
        view.style = .plain
        view.action = #selector(reloadButtonClicked)
        view.tintColor = .black
        view.image = UIImage(systemName: "goforward")
        return view
    }()
    
    private lazy var stopBarButton: UIBarButtonItem = {
        let view = UIBarButtonItem()
        view.target = self
        view.style = .plain
        view.action = #selector(stopButtonClicked)
        view.tintColor = .black
        view.image = UIImage(systemName: "xmark")
        return view
    }()
    
    private lazy var likeBarButton: UIBarButtonItem = {
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
        
        
        if (tasks.first(where: { $0.itemID == productID}) != nil) {
            print("잇어요")
            likeBarButton.image = UIImage(systemName: "heart.fill")
        } else {
            print("없어요")
            likeBarButton.image = UIImage(systemName: "heart")

        }
        navigationController?.setToolbarHidden(false, animated: true)
        setupToolBar()

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
                    let task = LikedTable(id: productInfo.productID, title: productInfo.noTagTitle, mallName: productInfo.mallName, lprice: productInfo.decimalPrice, imageURL: productInfo.image, likedDate: Date(), like: true)
                    
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
        view.addSubview(bottomToolbar)
        
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
        
        bottomToolbar.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
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
    
    @objc func reloadButtonClicked() {
        itemDetailWebView.reload()
    }
    
    @objc func stopButtonClicked() {
        itemDetailWebView.stopLoading()
        
    }
    
    @objc func goBackButtonClicked() {
        if itemDetailWebView.canGoBack {
            itemDetailWebView.goBack()
        }
    }
    
    @objc func goForwardButtonClicked() {
        if itemDetailWebView.canGoForward {
            itemDetailWebView.goForward()
        }
    }
    
    
    private func setupToolBar() {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        bottomToolbar.items = [
            flexibleSpace,
            backBarButton,
            flexibleSpace,
            reloadBarButton,
            flexibleSpace,
            stopBarButton,
            flexibleSpace,
            forwardBarButton,
            flexibleSpace
        ]
    }
    
}
