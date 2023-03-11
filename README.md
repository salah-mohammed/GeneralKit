# GeneralKit

GeneralKit  It was built  for every application that displays data in UITableView and UICollectionView from the network or from local data, support network management in Very clean code.   


# Features

* It is a Data management Library  support HTTP networking.
* Data display management in UITableView and UICollectionView,In an easy and simple way and with the least possible code by GeneralKit tools.
* Pagination.
* Support UIKit and SwiftUI(WithExample).
* Very clean code.
* Tools to present data in UITableView and UICollectionView.
* Placeholder for UITableView  and UICollectionView.
* Single,Multi and Single Section selection  for UITableView  and UICollectionView.
* Upload File / Data / Stream / MultipartFormData.
* URL / JSON Parameter Encoding.
* You can develop a project with very clear code
* Swift Concurrency Support Back to iOS 13.


# Requirements
* IOS 13+ 
* Swift 5+

# How used (configuration): 

# Pod install
```ruby
pod 'GeneralKit',:git => "https://github.com/salah-mohammed/GeneralKit.git"
 
```
- Normal request example

```swift
 RequestOperationBuilder<BaseResponse>.init()
 .baseRequest(UserRequest.init(.login(s_phone: nil)))
 .build()
 .responseHandler({ response in
        ResponseHandler.check(response, { baseResponse in
               print(baseResponse);
        })
   }).execute()
```
- Normal Request as GeneralKit Example
```swift
   RequestOperationBuilder<BaseResponse>.init()
    .baseRequest(UserRequest.init(.login(s_phone: nil)))
    .build()
    .executeWithCheckResponse { baseResponse in
            
     }
```
- Force Multipart Request 

```swift
 RequestOperationBuilder<BaseResponse>.init()
 .multipart(true)
 .baseRequest(UserRequest.init(.profile(image:nil)))
 .build()
 .responseHandler({ response in
        ResponseHandler.check(response, { baseResponse in
               print(baseResponse);
        })
   }).execute()
```
