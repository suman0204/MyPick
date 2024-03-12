<p align="left">
  <img width="100" alt="image" src="https://github.com/suman0204/SeSAC_2ndRecap/assets/18048754/2ce73bbc-c558-40aa-aa67-3337eab0c526">
</p>

# MyPick


**네이버 쇼핑을 통한 상품 검색 및 좋아요 기능으로 나만의 위시리스트 저장 앱**
<p align="center">
<img src="https://github.com/suman0204/SeSAC_2ndRecap/assets/18048754/1ff58af8-1e51-4427-8d67-f2dd3da80c2b" width="20%" height="30%">
<img src="https://github.com/suman0204/SeSAC_2ndRecap/assets/18048754/78041d0b-0b87-4d37-af42-42ba6d875b49" width="20%" height="30%">
<img src="https://github.com/suman0204/SeSAC_2ndRecap/assets/18048754/53d3b5cb-84e1-47fe-b1a6-44196ae5d589" width="20%" height="30%">
<img src="https://github.com/suman0204/SeSAC_2ndRecap/assets/18048754/82ed7625-8f77-4890-a1ec-3d90922f2004" width="20%" height="30%">
</p>


## 프로젝트 소개


> 앱 소개
> 
- 네이버 쇼핑 API 활용하여 상품 검색 및 페이지네이션
- 데이터베이스를 활용한 좋아요 추가 / 제거
- 좋아요한 상품 목록 검색

---

> 주요 기능
> 
- **Alamofire**를 통한 네이버 쇼핑 API 통신으로 쇼핑 검색 기능
- UICollectionView의 **prefetch** 메서드 기반 **Offset-based Paginaiton**
- **Repository Pattern**을 통한 **Realm** 추상화 및 상품 좋아요 추가 제거 기능
- **Webkit**을 통한 제품 상세페이지 화면 렌더링
- **Kingfisher**를 활용하여 이미지 비동기 다운로드 및 캐싱

---

> 개발 환경
> 
- 최소 버전 : iOS 13.0
- 개발 인원: 1인
- 개발 기간: 2023.09.07 ~ 2023.09.16

---

> 기술 스택
> 
- Swift
- UIKit, Webkit
- MVC, Repository
- Snapkit, Alamofire, Kingfisher, Realm

---

<br/>

## 트러블 슈팅


### **1. 좋아요한 상품 실시간 업데이트**

**문제**

좋아요를 통해 저장된 상품 리스트에서 상품의 상세 뷰에 들어가서 좋아요를 취소한 뒤 화면 밖을 나가면 인덱스 오류 발생
→ 좋아요한 상품의 좋아요 취소 시 viewDidDisappear에서 상품의 좋아요를 렘에서 삭제해서 갯수가 맞지않는 오류 발생

```swift
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 좋아요한 상품 취소 로직
        guard let productID = productID else {
            return
        }
        
        if likeBarButton.image == UIImage(systemName: "heart") {
            repository.deleteItem(id: productID)
        } else {
						...
        }
    }
```

**해결법**

viewWillDisapear에서 좋아요 취소한 목록을 업데이트 해주고 좋아요한 상품 리스트 화면으로 이동시 인덱스 오류가 발생하지 않고 실시간으로 목록을 업데이트 됨

```swift
    override func viewWillDisapear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 좋아요한 상품 취소 로직
        guard let productID = productID else {
            return
        }
        
        if likeBarButton.image == UIImage(systemName: "heart") {
            repository.deleteItem(id: productID)
        } else {
						...
        }
    }
```

<br/>

---

<br/>

### 2. 이미지 다운로드 시 과도한 메모리 사용

**문제**

Kingfisher를 통해 API에서 받아오는 이미지를 셀에 보여주는 과정에서 과도한 메모리 사용이 발생

<img width="1392" alt="스크린샷 2024-02-13 오전 12 32 39" src="https://github.com/suman0204/SeSAC_2ndRecap/assets/18048754/c222b24c-bf50-47ce-9050-41c86476485f">

```swift
func inputAPIData(data: ItemResult) {
    imageView.kf.setImage(with: URL(string: data.image))
        
    mallNameLabel.text = "[\(data.mallName)]"
    titleLabel.text = data.noTagTitle
    priceLabel.text = data.decimalPrice
}
```

**해결법**

Kingfisher의 이미지 캐싱과 다운샘플링 기능을 통해 이미지 데이터 리소스를 최소화하였고 이를 통해 과도한 메모리 사용 문제 해결

<img width="1292" alt="스크린샷 2024-02-13 오전 12 42 50" src="https://github.com/suman0204/SeSAC_2ndRecap/assets/18048754/e07828b2-4565-4ecc-9cbf-4a20bb647de6">

```swift
func inputAPIData(data: ItemResult) {
    imageView.kf.setImage(with: URL(string: data.image), 
    placeholder: UIImage(), options: [
    .processor(DownsamplingImageProcessor(size: CGSize(width: 200, height: 200))), 
    .scaleFactor(UIScreen.main.scale), 
    .cacheOriginalImage], 
     completionHandler: nil)
        
    mallNameLabel.text = "[\(data.mallName)]"
    titleLabel.text = data.noTagTitle
    priceLabel.text = data.decimalPrice
}
```
