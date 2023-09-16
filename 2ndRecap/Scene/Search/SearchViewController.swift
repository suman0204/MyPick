//
//  SearchViewController.swift
//  2ndRecap
//
//  Created by 홍수만 on 2023/09/09.
//

import UIKit
import RealmSwift

class SearchViewController: BaseViewController {
    
    var tasks: Results<LikedTable>!
    
    let repository = LikedTableRepository()
    
    var itemResultList: [ItemResult] = []
    
    private var start = 1
    
    var searchQuery: String?
    
    var sortType: SortType = SortType.sim
    
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
    
    let simButton = {
        let view = GrayBorderButton()
        view.setTitle(SortType.sim.typeName, for: .normal)
        return view
    }()
    
    let dateButton = {
        let view = GrayBorderButton()
        view.setTitle(SortType.date.typeName, for: .normal)
        return view
    }()
    
    var ascButton = {
        let view = GrayBorderButton()
        view.setTitle(SortType.asc.typeName, for: .normal)
        return view
    }()
    
    let dscButton = {
        let view = GrayBorderButton()
        view.setTitle(SortType.dsc.typeName, for: .normal)
        return view
    }()
    
    let sortTypeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        
        return stackView
    }()
    
    lazy var searchResultsCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.reuseIdentifier)
        view.backgroundColor = Constants.BaseColor.background
        view.delegate = self
        view.dataSource = self
        view.prefetchDataSource = self
        view.collectionViewLayout = collectionViewLayout()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "쇼핑 검색"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        searchBar.delegate = self
       
        searchResultsCollectionView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        
        tasks = repository.fetch()
        print(tasks)
        addTargetSortButton()
        
        hideKeyboard()
        
        print("검색화면")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viedidappear")
        searchResultsCollectionView.reloadData()
    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
////        view.endEditing(true)
//        searchBar.resignFirstResponder()
//        print("touchBegan")
//    }
//
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
  
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
            action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    override func configureView() {
        
        [simButton, dateButton, ascButton, dscButton].forEach {
            sortTypeStackView.addArrangedSubview($0)
        }
        
        [searchBar, sortTypeStackView, searchResultsCollectionView].forEach {
            view.addSubview($0)
        }
    
    }
    
    override func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        sortTypeStackView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(15)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-120)
//            make.height.equalTo(30)
        }
        
        searchResultsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(sortTypeStackView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        print("vc setconstr")
    }
}


extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            print(itemResultList.count)
            if itemResultList.count - 1 == indexPath.item && start < 1000 {
                start += 30
                print("start: \(start)")
                guard let query = searchBar.text else {
                    //검색어 입력 안내 alert 띄우기
                    return
                }
                
                ShoppingAPIManager.shared.callRequest(query: query, start: start, sort: sortType) { result in
                    
                    print("pagination result")
                    print(result)
                    self.itemResultList.append(contentsOf: result.items)
                    
                    print("pagination")
                    print(self.itemResultList)
                    DispatchQueue.main.async {
                        self.searchResultsCollectionView.reloadData()
                        
                    }
                } failure: {
                    print("error")
                }

            }
        }
    }
    
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        print("print layout")
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        let size = UIScreen.main.bounds.width - 45
        layout.itemSize = CGSize(width: size / 2, height: size / 1.3)
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemResultList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.reuseIdentifier, for: indexPath) as? SearchCollectionViewCell else {
            return UICollectionViewCell()
        }
        print("cellforitemat")
        let data = itemResultList[indexPath.item]

        if (tasks.first(where: { $0.itemID == data.productID}) != nil) {
            print("잇어요")
            cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            print("없어요")
            cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)

        }

        cell.inputAPIData(data: data)

        cell.likeButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        
        print(#function)
        print(cell.likeButton.bounds.width / 2)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        let data = itemResultList[indexPath.item]
        
        vc.productInfo = data
//        vc.viewType = .searchView
        vc.navTitle = data.title.removeTags()
        vc.productID = data.productID
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
//    @objc func likeButtonClickedFirst(_ sender: UIButton) {
//        print("like")
//
//        if let cell = sender.superview?.superview as? SearchCollectionViewCell,
//           let indexPath = searchResultsCollectionView.indexPath(for: cell) {
//            var selectedItem = itemResultList[indexPath.item]
//            selectedItem.like.toggle() // like 상태를 반전시킴
//            print("dd",selectedItem)
//            itemResultList[indexPath.item] = selectedItem
//
//            cell.like = selectedItem.like
//
//            if !selectedItem.like {
//                cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
//
//                repository.deleteItem(id: selectedItem.productID)
//            } else {
//                cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//
//                let path = documentDirectoryPath()
//                print(path)
//
//                let task = LikedTable(id: selectedItem.productID, title: selectedItem.title, mallName: selectedItem.mallName, lprice: selectedItem.lprice, imageURL: selectedItem.image, likedDate: Date(), like: selectedItem.like)
//
//                repository.createItem(task)
////                LikedViewController().searchResultsCollectionView.reloadData()
//            }
////            searchResultsCollectionView.reloadItems(at: [indexPath])
//
//        }
//
//    }
    
    @objc func likeButtonClicked(_ sender: UIButton) {
        print("likebuttonclicked")
        if let cell = sender.superview?.superview as? SearchCollectionViewCell,
           let indexPath = searchResultsCollectionView.indexPath(for: cell) {
            
            let selectedItem = itemResultList[indexPath.item]

            if cell.likeButton.currentImage == UIImage(systemName: "heart") {
                print("heart")
                cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                
                let task = LikedTable(id: selectedItem.productID, title: selectedItem.noTagTitle, mallName: selectedItem.mallName, lprice: selectedItem.decimalPrice, imageURL: selectedItem.image, likedDate: Date(), like: true)
                
                repository.createItem(task)

            } else {
                print("fill")
                
                cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                repository.deleteItem(id: selectedItem.productID)
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        start = 1
        
        itemResultList.removeAll()
        
        guard let query = searchBar.text else {
            //검색어 비어있을 때 입력 안내 alert 띄우기
            requestInsertWord()
            return
        }
        
        searchQuery = query
        
        guard let searchQuery = searchQuery else {
            return
        }
        
        ShoppingAPIManager.shared.callRequest(query: searchQuery, start: start, sort: SortType.sim) { result in
            print(result)
            
            if result.items.count == 0 {
                //검색 결과 0개이면 결과 없다고 alert 띄우기
                self.noResultAlert()
            } else {
                self.itemResultList = result.items
                self.searchResultsCollectionView.reloadData()
                self.scrollToTop()
                self.changeButtonStyle(toWhite: self.simButton, toBlack: [self.dateButton, self.ascButton, self.dscButton])
            }
            
        } failure: {
            //검색 결과 없음 alert띄우기
            self.noResultAlert()

            print("Error")
        }
        
        searchBar.resignFirstResponder()
        
        print("searchbuttonClicked")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
//        itemResultList.removeAll()
        searchResultsCollectionView.reloadData()
    }
    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        if searchBar.text == "" {
//            itemResultList.removeAll()
//            searchResultsCollectionView.reloadData()
//        }
//    }
}

extension SearchViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension SearchViewController {
    private func decimalFormat(price: Int) -> String? {
        let numberFommater: NumberFormatter = NumberFormatter()
        numberFommater.numberStyle = .decimal
        return numberFommater.string(for: price)
    }
    
    @objc private func simButtonClicked() {
        
        changeButtonStyle(toWhite: simButton, toBlack: [dateButton, ascButton, dscButton])

//        guard let query = searchBar.text else {
//            //검색어 비어있을 때 입력 안내 alert 띄우기
//            requestInsertWord()
//            return
//        }
        
        guard let searchQuery = searchQuery else {
            return
        }
        if searchQuery == "" {
            requestInsertWord()
        } else {
            sortType = SortType.sim
            
            ShoppingAPIManager.shared.callRequest(query: searchQuery, start: start, sort: sortType) { result in
                print(result)
                if result.items.count == 0 {
                    //검색 결과 0개이면 결과 없다고 alert 띄우기
                    self.noResultAlert()
                } else {
                    self.itemResultList = result.items
                    self.searchResultsCollectionView.reloadData()
                }
            } failure: {
                //검색 결과 없음 alert띄우기
                self.noResultAlert()
                
                print("Error")
            }
            
            scrollToTop()
        }
    }
    
    @objc private func dateButtonClicked() {
        
        changeButtonStyle(toWhite: dateButton, toBlack: [simButton, ascButton, dscButton])
        
//        guard let query = searchBar.text else {
//            //검색어 비어있을 때 입력 안내 alert 띄우기
//            requestInsertWord()
//            return
//        }
        
        guard let searchQuery = searchQuery else {
            return
        }
        
        if searchQuery == "" {
            requestInsertWord()
        } else {
            sortType = SortType.date
            
            ShoppingAPIManager.shared.callRequest(query: searchQuery, start: start, sort: sortType) { result in
                print(result)
                if result.items.count == 0 {
                    //검색 결과 0개이면 결과 없다고 alert 띄우기
                    self.noResultAlert()
                } else {
                    self.itemResultList = result.items
                    self.searchResultsCollectionView.reloadData()
                }
            } failure: {
                //검색 결과 없음 alert띄우기
                self.noResultAlert()
                
                print("Error")
            }
            
            scrollToTop()
        }
    }
    
    @objc private func ascButtonClicked(){
        
        changeButtonStyle(toWhite: ascButton, toBlack: [simButton, dateButton, dscButton])
        
//        guard let query = searchBar.text else {
//            //검색어 비어있을 때 입력 안내 alert 띄우기
//            requestInsertWord()
//            return
//        }
        
        guard let searchQuery = searchQuery else {
            return
        }
        
        if searchQuery == "" {
            requestInsertWord()
        } else {
            sortType = SortType.asc
            
            ShoppingAPIManager.shared.callRequest(query: searchQuery, start: start, sort: sortType) { result in
                print(result)
                if result.items.count == 0 {
                    //검색 결과 0개이면 결과 없다고 alert 띄우기
                    self.noResultAlert()
                } else {
                    self.itemResultList = result.items
                    self.searchResultsCollectionView.reloadData()
                }
            } failure: {
                //검색 결과 없음 alert띄우기
                self.noResultAlert()
                
                print("Error")
            }
            
            scrollToTop()
        }
    }
    
    @objc private func dscButtonClicked(){
        
        changeButtonStyle(toWhite: dscButton, toBlack: [simButton, dateButton, ascButton])
        
//        guard let query = searchBar.text else {
//            //검색어 비어있을 때 입력 안내 alert 띄우기
//            return
//        }
        
        guard let searchQuery = searchQuery else {
            return
        }
        
        if searchQuery == "" {
            requestInsertWord()
        } else {
            sortType = SortType.dsc
            
            ShoppingAPIManager.shared.callRequest(query: searchQuery, start: start, sort: sortType) { result in
                print(result)
                if result.items.count == 0 {
                    //검색 결과 0개이면 결과 없다고 alert 띄우기
                    self.noResultAlert()
                } else {
                    self.itemResultList = result.items
                    self.searchResultsCollectionView.reloadData()
                }
            } failure: {
                //검색 결과 없음 alert띄우기
                self.noResultAlert()
                
                print("Error")
            }
            
            scrollToTop()
        }
    }
    
    private func addTargetSortButton() {
        simButton.addTarget(self, action: #selector(simButtonClicked), for: .touchUpInside)
        dateButton.addTarget(self, action: #selector(dateButtonClicked), for: .touchUpInside)
        ascButton.addTarget(self, action: #selector(ascButtonClicked), for: .touchUpInside)
        dscButton.addTarget(self, action: #selector(dscButtonClicked), for: .touchUpInside)
    }
    
    private func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -searchResultsCollectionView.contentInset.top)
        searchResultsCollectionView.setContentOffset(desiredOffset, animated: true)
    }
    
//    private func requestInsertWord() {
//        let alert = UIAlertController(title: "검색어를 입력하세요", message: "검색어 입력 후 검색해주세요!", preferredStyle: .alert)
//
//        let ok = UIAlertAction(title: "확인", style: .default)
//
//        alert.addAction(ok)
//
//        present(alert, animated: true)
//
//    }
    
//    private func noResultAlert() {
//        let alert = UIAlertController(title: "검색 결과가 없습니다", message: "다른 검색어를 입력해주세요", preferredStyle: .alert)
//
//        let ok = UIAlertAction(title: "확인", style: .default)
//
//        alert.addAction(ok)
//
//        present(alert, animated: true)
//    }
    
    private func changeToWhiteButton(button: UIButton) {
        button.layer.cornerRadius = Constants.Design.cornerRadius
        button.layer.borderWidth = Constants.Design.borderWidth
        button.layer.borderColor = Constants.BaseColor.border
        button.setTitleColor(Constants.BaseColor.background, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.backgroundColor = .white
    }
    
    private func changeToGrayBorderButton(button: UIButton) {
        button.layer.cornerRadius = Constants.Design.cornerRadius
        button.layer.borderWidth = Constants.Design.borderWidth
        button.layer.borderColor = Constants.BaseColor.placeholder.cgColor
        button.setTitleColor(Constants.BaseColor.placeholder, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.backgroundColor = .black
    }
    
    private func changeButtonStyle(toWhite: UIButton, toBlack: [UIButton]) {
        changeToWhiteButton(button: toWhite)
        
        toBlack.forEach {
            changeToGrayBorderButton(button: $0)
        }
    }
}
