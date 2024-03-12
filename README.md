# MyPick

---

**네이버 쇼핑을 통한 상품 검색 및 좋아요 기능으로 나만의 위시리스트 저장 앱**

![Simulator Screenshot - iPhone 15 Pro - 2024-02-13 at 00.47.42.png](https://prod-files-secure.s3.us-west-2.amazonaws.com/2e59db1b-691d-487c-9eca-b5f25e2289b1/84ec042a-a000-47a0-a347-c4334ae6e70f/Simulator_Screenshot_-_iPhone_15_Pro_-_2024-02-13_at_00.47.42.png)

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/2e59db1b-691d-487c-9eca-b5f25e2289b1/27f4be64-9494-4d0f-8167-bfb156805019/Untitled.png)

![Simulator Screenshot - iPhone 15 Pro - 2024-02-13 at 01.10.38.png](https://prod-files-secure.s3.us-west-2.amazonaws.com/2e59db1b-691d-487c-9eca-b5f25e2289b1/c76024a8-66d8-44e1-8b71-cf1379ab585f/Simulator_Screenshot_-_iPhone_15_Pro_-_2024-02-13_at_01.10.38.png)

![Simulator Screenshot - iPhone 15 Pro - 2024-02-13 at 01.10.49.png](https://prod-files-secure.s3.us-west-2.amazonaws.com/2e59db1b-691d-487c-9eca-b5f25e2289b1/6892585d-0886-4cd0-9862-b2035b5ddd1e/Simulator_Screenshot_-_iPhone_15_Pro_-_2024-02-13_at_01.10.49.png)

## 프로젝트 소개

---

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

## 트러블 슈팅

---

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

### 2. 이미지 다운로드 시 과도한 메모리 사용

**문제**

Kingfisher를 통해 API에서 받아오는 이미지를 셀에 보여주는 과정에서 과도한 메모리 사용이 발생

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/2e59db1b-691d-487c-9eca-b5f25e2289b1/9cf18397-0fdf-41a0-b7e3-2d89c5dca2ff/Untitled.png)

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

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/2e59db1b-691d-487c-9eca-b5f25e2289b1/bd77c06d-d103-403e-8981-5507a50aa82e/Untitled.png)

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
