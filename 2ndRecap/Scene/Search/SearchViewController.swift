//
//  SearchViewController.swift
//  2ndRecap
//
//  Created by 홍수만 on 2023/09/09.
//

import UIKit

class SearchViewController: BaseViewController {
    
    var itemResultList: [ItemResult] = []
    
    var page = 1
    
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
        
        addTargetSortButton()
        
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
    }
}


extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            print(itemResultList.count)
            if itemResultList.count - 1 == indexPath.item && page < 1000 {
                page += 1
                print("page: \(page)")
                guard let query = searchBar.text else {
                    //검색어 입력 안내 alert 띄우기
                    return
                }
                
                ShoppingAPIManager.shared.callRequest(query: query, page: page, sort: sortType) { result in
                    
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

        let data = itemResultList[indexPath.item]
//        print("cellforitemat")
//        print(data)
        
        cell.imageView.kf.setImage(with: URL(string: data.image))
        cell.mallNameLabel.text = "[\(data.mallName)]"
        cell.titleLabel.text = data.title.removeTags()

        cell.priceLabel.text = decimalFormat(price: Int(data.lprice) ?? 0)
        
//        cell.likeButton.becomeFirstResponder()
        cell.likeButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        let data = itemResultList[indexPath.item]
        
        vc.navTitle = data.title.removeTags()
        vc.productID = data.productID
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func likeButtonClicked() {
        print("like")
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        page = 1
        
        itemResultList.removeAll()
        
        guard let query = searchBar.text else {
            //검색어 비어있을 때 입력 안내 alert 띄우기
            requestInsertWord()
            return
        }
        ShoppingAPIManager.shared.callRequest(query: query, page: page, sort: SortType.sim) { result in
            print(result)
            
            if result.items.count == 0 {
                //검색 결과 0개이면 결과 없다고 alert 띄우기
                self.noResultAlert()
            } else {
                self.itemResultList = result.items
                self.searchResultsCollectionView.reloadData()
                self.changeToWhiteButton(button: self.simButton)
            }
            
        } failure: {
            //검색 결과 없음 alert띄우기
            self.noResultAlert()

            print("Error")
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchResultsCollectionView.reloadData()
    }
}


extension SearchViewController {
    func decimalFormat(price: Int) -> String? {
        let numberFommater: NumberFormatter = NumberFormatter()
        numberFommater.numberStyle = .decimal
        return numberFommater.string(for: price)
    }
    
    @objc func simButtonClicked() {
        
        changeButtonStyle(toWhite: simButton, toBlack: [dateButton, ascButton, dscButton])

        guard let query = searchBar.text else {
            //검색어 비어있을 때 입력 안내 alert 띄우기
            requestInsertWord()
            return
        }
        if query == "" {
            requestInsertWord()
        } else {
            sortType = SortType.sim
            
            ShoppingAPIManager.shared.callRequest(query: query, page: page, sort: sortType) { result in
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
    
    @objc func dateButtonClicked() {
        
        changeButtonStyle(toWhite: dateButton, toBlack: [simButton, ascButton, dscButton])
        
        guard let query = searchBar.text else {
            //검색어 비어있을 때 입력 안내 alert 띄우기
            requestInsertWord()
            return
        }
        if query == "" {
            requestInsertWord()
        } else {
            sortType = SortType.date
            
            ShoppingAPIManager.shared.callRequest(query: query, page: page, sort: sortType) { result in
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
    
    @objc func ascButtonClicked(){
        
        changeButtonStyle(toWhite: ascButton, toBlack: [simButton, dateButton, dscButton])
        
        guard let query = searchBar.text else {
            //검색어 비어있을 때 입력 안내 alert 띄우기
            requestInsertWord()
            return
        }
        
        if query == "" {
            requestInsertWord()
        } else {
            sortType = SortType.asc
            
            ShoppingAPIManager.shared.callRequest(query: query, page: page, sort: sortType) { result in
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
    
    @objc func dscButtonClicked(){
        
        changeButtonStyle(toWhite: dscButton, toBlack: [simButton, dateButton, ascButton])
        
        guard let query = searchBar.text else {
            //검색어 비어있을 때 입력 안내 alert 띄우기
            return
        }
        if query == "" {
            requestInsertWord()
        } else {
            sortType = SortType.dsc
            
            ShoppingAPIManager.shared.callRequest(query: query, page: page, sort: sortType) { result in
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
    
    func addTargetSortButton() {
        simButton.addTarget(self, action: #selector(simButtonClicked), for: .touchUpInside)
        dateButton.addTarget(self, action: #selector(dateButtonClicked), for: .touchUpInside)
        ascButton.addTarget(self, action: #selector(ascButtonClicked), for: .touchUpInside)
        dscButton.addTarget(self, action: #selector(dscButtonClicked), for: .touchUpInside)
    }
    
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -searchResultsCollectionView.contentInset.top)
        searchResultsCollectionView.setContentOffset(desiredOffset, animated: true)
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
    
    func changeToWhiteButton(button: UIButton) {
        button.layer.cornerRadius = Constants.Design.cornerRadius
        button.layer.borderWidth = Constants.Design.borderWidth
        button.layer.borderColor = Constants.BaseColor.border
        button.setTitleColor(Constants.BaseColor.background, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.backgroundColor = .white
    }
    
    func changeToGrayBorderButton(button: UIButton) {
        button.layer.cornerRadius = Constants.Design.cornerRadius
        button.layer.borderWidth = Constants.Design.borderWidth
        button.layer.borderColor = Constants.BaseColor.placeholder.cgColor
        button.setTitleColor(Constants.BaseColor.placeholder, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.backgroundColor = .black
    }
    
    func changeButtonStyle(toWhite: UIButton, toBlack: [UIButton]) {
        changeToWhiteButton(button: toWhite)
        
        toBlack.forEach {
            changeToGrayBorderButton(button: $0)
        }
    }
}
