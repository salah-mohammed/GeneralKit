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
# How used (Webservice configuration only):
- Base Request
```swift
import Foundation
import GeneralKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class UserRequest:BaseRequest{
    override var baseUrl:String{
    return  "https://www.google.com"
    }
    public enum Route{
        case users
        case login
    }
    private var route:Route
    init(_ route:Route) {
        self.route = route
    }
    override var path:String?{
        switch self.route{
        case .users:
            return "usersList\(self.page ?? "1").json";
        case .login:
            return "login"
        }
    }  // for request path
    override var header : HTTPHeaders?{
        return nil
    }
    override var parameters:Parameters{
        let parameters =  super.parameters
        switch self.route{
        case .users:
            break;
        case .login:
            break;
        }
        return parameters;
    } // request paramter
    override var type:HTTPMethod!{
        switch self.route{
        case .login,.users:
            return .get
        }
    } // for post type : .post,.get,.delete
    override var multiPartObjects : [ValidationObject.MultiPartObject]{
        let items = [ValidationObject.MultiPartObject]();
        switch self.route{
        case .users,.login:
            return items
        }
    }
}
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
- Parameter Encoding use(JSONEncoding.default or URLEncoding.default)
```swift
 RequestOperationBuilder<BaseResponse>.init()
 .encoding(JSONEncoding.default)
 .baseRequest(UserRequest.init(.login(s_phone: nil)))
 .build()
 .responseHandler({ response in
        ResponseHandler.check(response, { baseResponse in
               print(baseResponse);
        })
   }).execute()
```
# How used (Webservice  and UIKit):
- UITableView with Pagination Example
```swift
import UIKit
import GeneralKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class TableListExampleViewController: UIViewController {
    @IBOutlet weak var tableView:GeneralTableView!
    var paginationManager:PaginationManager<BaseResponse>=PaginationManager<BaseResponse>.init()
    var paginationResponseHandler:PaginationResponseHandler?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.bs_registerNib(NibName:"NewTableViewCell");
        paginationSetup();
        tableView.paginationManager(paginationManager).identifier("NewTableViewCell").start();
    }
    func paginationSetup(){
        paginationResponseHandler=PaginationResponseHandler.init(self.paginationManager);
        paginationManager.baseRequest(UserRequest.init(.users));
        self.paginationManager.responseHandler { response in
            
            if response.value?.pagination?.i_current_page == 1{
                self.tableView.handleAny(.objects([response.value?.users ?? []]),response.error)
            }else{
                self.tableView.handleAny(.appendItemsInSection(atRow: nil,response.value?.users ?? []),response.error)
            }
        }
    }

}
```

- UICollectionView with Pagination Example with selection feature for items
```swift
//
//  CollectionListExampleViewController.swift
//  GeneralKitUIKitExample
//
//  Created by SalahMohamed on 24/10/2022.
//

import UIKit
import GeneralKit
class CollectionListExampleViewController: UIViewController {
    @IBOutlet weak var collectionView:GeneralCollectionView!
    var paginationManager:PaginationManager<BaseResponse>=PaginationManager<BaseResponse>.init()
    var paginationResponseHandler:PaginationResponseHandler?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView();
        setupData();
        paginationSetup();
    }
    func setupView(){
        collectionView.bs_register("NewCollectionViewCell")
    }
    func setupData(){
        collectionView.selectionType = .multi
        collectionView.converterHandler { item in
            let value = (UIScreen.main.bounds.width-40)/2;
            return GeneralCellData.init(identifier:"NewCollectionViewCell", object: item,cellSize:CGSize.init(width:value, height:value))
        }
        collectionView.containsHandler = { object1 , object2 in
        return (object1 as? User)?.id == (object2 as? User)?.id
        }
    }
    func paginationSetup(){
        paginationResponseHandler=PaginationResponseHandler.init(self.paginationManager);
        paginationManager.baseRequest(UserRequest.init(.users));
        self.paginationManager.responseHandler { response in
            ResponseHandler.check(response,{ baseResponse in
                
            })

            if response.value?.pagination?.i_current_page == 1{
                self.collectionView.handleAny(.objects([response.value?.users ?? []]))
            }else{
                self.collectionView.handleAny(.appendItemsInSection(atRow: nil, response.value?.users ?? []))
            }
        }
        collectionView.paginationManager(paginationManager).identifier("NewCollectionViewCell").start();
    }
}
```
- GeneralKit Tools to present data in UITableView and UICollectionView.

```swift
public enum AnyHandling{
case objects([[Any]])
case appendObject(section:Int=0,atRow:Int?,Any)
case appendNewSection(Int?,[Any])
case appendItemsInSection(section:Int=0,atRow:Int?,[Any])
case replaceObject(IndexPath,Any)

}
public enum DataHandling{
case objects([[GeneralCellData]])
case appendObject(section:Int=0,atRow:Int?,GeneralCellData)
case appendNewSection(Int?,[GeneralCellData]) 
case appendItemsInSection(section:Int=0,atRow:Int?,[GeneralCellData])
case replaceObject(IndexPath,GeneralCellData) 

}
```

- default placeholder view for (UITableView and for UICollectionView): 
 put this code in App Delegate for (UITableView and for UICollectionView) in your app.
```swift
GeneralListConstant.global.loadingDataHandler = {
      let view = ListPlaceHolderView.loadViewFromNib()
      view.data=LoadingData
      return view
 }
GeneralListConstant.global.errorConnectionDataViewHandler = {
      let view = ListPlaceHolderView.loadViewFromNib()
      view.data=ErrorConnection
      return view
 }
GeneralListConstant.global.emptyDataViewHandler = {
      let view = ListPlaceHolderView.loadViewFromNib()
      view.data=EmptyData
      return view
 }
```

# How used (Webservice  and SwiftUI):
- List with Pagination Example
```swift
import Foundation
import GeneralKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

typealias ActionHandler = ()->Void
class ItemsViewModel:NSObject,ObservableObject{
    @Published  var list:[User] = []
    var paginationManager:PaginationManager<BaseResponse>=PaginationManager<BaseResponse>.init()
    var paginationResponseHandler:PaginationResponseHandler
    override init() {
        paginationResponseHandler=PaginationResponseHandler.init(self.paginationManager);
        super.init();
        paginationSetup();

    }
    func refresh()->ActionHandler{
        let actionHandler = {
            self.paginationManager.start();
        }
        return actionHandler;
    }
    func loadMore()->ActionHandler{
        let actionHandler = {
        self.paginationManager.loadNextPage();
        }
        return actionHandler;
    }
    func paginationSetup(){
        paginationManager.baseRequest(UserRequest.init(.users));
        self.paginationManager.responseHandler { response in
            ResponseHandler.check(response,{ baseResponse in
                
            })
            if response.value?.pagination?.i_current_page == 1{
                self.list = response.value?.users ?? []
            }else{
                self.list.append(contentsOf: response.value?.users ?? [])
            }
        }
        self.paginationManager.start();
    }
}
```
