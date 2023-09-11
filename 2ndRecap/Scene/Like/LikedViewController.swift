//
//  LikedViewController.swift
//  2ndRecap
//
//  Created by 홍수만 on 2023/09/09.
//

import UIKit
import RealmSwift

class LikedViewController: BaseViewController {
    
    var tasks: Results<LikedTable>!
    
    let repository = LikedTableRepository()
    
    let searchBar = {
        let view = UISearchBar()
        view.placeholder = "검색어를 입력해주세요"
        view.barTintColor = .black
        view.searchTextField.textColor = .white
        view.tintColor = .white
        view.setValue("취소", forKey: "cancelButtonText")
        view.setShowsCancelButton(true, animated: true)
        return view
    }()
    
    lazy var searchResultsCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.reuseIdentifier)
        view.backgroundColor = Constants.BaseColor.background
        view.delegate = self
        view.dataSource = self
        view.collectionViewLayout = collectionViewLayout()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("likedView")
        
        title = "쇼핑 검색"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        searchBar.delegate = self
        
        searchResultsCollectionView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        
        tasks = repository.fetch()
        print(tasks)
    }
    
    override func configureView() {
        [searchBar, searchResultsCollectionView].forEach {
            view.addSubview($0)
        }
    
    }
    
    override func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }

        
        searchResultsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}


extension LikedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        let size = UIScreen.main.bounds.width - 45
        layout.itemSize = CGSize(width: size / 2, height: size / 1.3)
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.reuseIdentifier, for: indexPath) as? SearchCollectionViewCell else {
            return UICollectionViewCell()
        }

        var data = tasks[indexPath.item]
        
        cell.inputRealmData(data: data)

        cell.likeButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        let data = tasks[indexPath.item]
        
        vc.navTitle = data.itemTitle.removeTags()
        vc.productID = data.itemID
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func likeButtonClicked(_ sender: UIButton) {
        print("like")
        if let cell = sender.superview?.superview as? SearchCollectionViewCell,
           let indexPath = searchResultsCollectionView.indexPath(for: cell) {
            
            let realm = try! Realm()

            var selectedItem = tasks[indexPath.item]
          
            try! realm.write {
                if tasks[indexPath.item].like == false {
//                    realm.create(LikedTable.self, value: ["itemID": tasks[indexPath.item].itemID ,"like": true], update: .modified)
                    tasks[indexPath.item].like = true
                    print(tasks[indexPath.item])
                } else if tasks[indexPath.item].like == true {
//                    realm.create(LikedTable.self, value: ["like": false], update: .modified)
                    tasks[indexPath.item].like = false
                    print(tasks[indexPath.item])


                }
//                realm.create(LikedTable.self, value: ["like": tasks[indexPath.item].like.toggle()], update: .modified)
            }
            print(tasks[indexPath.item])
//            print("dd",selectedItem)
//            tasks[indexPath.item] = selectedItem
//
//            cell.like = selectedItem.like
            

           
           
            if !selectedItem.like {
                cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                        repository.deleteItem(id: tasks[indexPath.item].itemID)
                        searchResultsCollectionView.reloadData()
                
            } else {
                cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                //
                //                let path = documentDirectoryPath()
                //                print(path)
                //
                //                let task = LikedTable(id: selectedItem.productID, title: selectedItem.title, mallName: selectedItem.mallName, lprice: selectedItem.lprice, imageURL: selectedItem.image, likedDate: Date(), like: selectedItem.like)
                //
                //                repository.createItem(task)
            }
            
                
//            searchResultsCollectionView.reloadItems(at: [indexPath])

        }
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    
}

extension LikedViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
//        page = 1
//
//        itemResultList.removeAll()
        
        guard let query = searchBar.text else {
            //검색어 비어있을 때 입력 안내 alert 띄우기
            requestInsertWord()
            return
        }
//        ShoppingAPIManager.shared.callRequest(query: query, page: page, sort: SortType.sim) { result in
//            print(result)
//            
//            if result.items.count == 0 {
//                //검색 결과 0개이면 결과 없다고 alert 띄우기
//                self.noResultAlert()
//            } else {
//                self.itemResultList = result.items
//                self.searchResultsCollectionView.reloadData()
//                self.changeToWhiteButton(button: self.simButton)
//            }
//            
//        } failure: {
//            //검색 결과 없음 alert띄우기
//            self.noResultAlert()
//
//            print("Error")
//        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchResultsCollectionView.reloadData()
    }
}

extension LikedViewController {
    private func requestInsertWord() {
        let alert = UIAlertController(title: "검색어를 입력하세요", message: "검색어 입력 후 검색해주세요!", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "확인", style: .default)
        
        alert.addAction(ok)
        
        present(alert, animated: true)

    }
}
