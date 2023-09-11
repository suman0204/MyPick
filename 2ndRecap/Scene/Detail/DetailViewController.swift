//
//  DetailViewController.swift
//  2ndRecap
//
//  Created by 홍수만 on 2023/09/10.
//

import UIKit
import WebKit

class DetailViewController: BaseViewController {
    
    var itemDetailWebView: WKWebView = WKWebView()
    
    var navTitle: String?
    
    var productID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let navTitle = navTitle else {
            print("No Title")
            return
        }
        print(navTitle)
        title = navTitle

//        UIBarButtonItemAppearance.setValue(<#T##value: Any?##Any?#>, forKey: <#T##String#>)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(likeBarButtonClicked))
    }
    
    @objc func likeBarButtonClicked() {
        print("barbutton")
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
        
    }
    
    override func setConstraints() {
        itemDetailWebView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
