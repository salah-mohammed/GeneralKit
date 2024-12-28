# GeneralKit

GeneralKit is a Swift framework for HTTP networking and data handling in UITableView and UICollectionView, providing a complete vision for clean, efficient network-driven apps.

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
* OSX 10.15+ 

## Support The Project
Buy me a coffee and support me on [Buy me acoffee](https://buymeacoffee.com/salahalimou).

<a href="https://buymeacoffee.com/salahalimou">
<img width=25% alt="yellow-button" src="https://user-images.githubusercontent.com/1888355/146226808-eb2e9ee0-c6bd-44a2-a330-3bbc8a6244cf.png">
</a>



# Pod install
```ruby
pod 'GeneralKit',:git => "https://github.com/salah-mohammed/GeneralKit.git"
 
```
# How used (Webservice configuration):
- Base Request
```swift
import Foundation
import GeneralKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class UserRequest:BaseRequest{
    override var baseUrl:String{
    return  "https://nfcard.online/Salah/"
    }
    public enum Route{
        case users
        case login
        case profile(image:Data?=nil)
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
        case .profile(image: let image):
            return "profile"
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
        case .profile:
            break;
        }
        return parameters;
    } // request paramter
    override var type:HTTPMethod!{
        switch self.route{
        case .profile,.login:
            return .post
        case .users:
            return .get
        }
    } // for post type : .post,.get,.delete
    override var multiPartObjects : [ValidationObject.MultiPartObject]{
        var items = [ValidationObject.MultiPartObject]();
        switch self.route{
        case .users,.login:
            return items
        case .profile(image:let imageData):
            if let imageData:Data = imageData{
                let multiPartObject = ValidationObject.MultiPartObject.init(data:imageData, name:"photo", fileName:"file.png", mimeType: "image/*");
                items.append(multiPartObject)
            }
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
- Force Multipart Request always

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
- For (Multipart if have data) 
 first:
```swift
 RequestOperationBuilder<BaseResponse>.init()
 .baseRequest(UserRequest.init(.profile(image:nil)))
 .build()
 .responseHandler({ response in
        ResponseHandler.check(response, { baseResponse in
               print(baseResponse);
        })
   }).execute()
```
- For (Multipart if have data) 
second: in Your request class for Example: in UserRequest.swift
```swift
    override var multiPartObjects : [ValidationObject.MultiPartObject]{
        var items = [ValidationObject.MultiPartObject]();
        switch self.route{
        case .users,.login:
            return items
        case .profile(image:let imageData):
            if let imageData:Data = imageData{
                let multiPartObject = ValidationObject.MultiPartObject.init(data:imageData, name:"photo", fileName:"file.png", mimeType: "image/*");
                items.append(multiPartObject)
            }
            return items
        }
    }
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
# How used (Webservice and UIKit):
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
- Selection Feature setup(for UITableView and UICollectionView).
```swift
 collectionView.selectionType = .multi // for multi select
 /*or*/collectionView.selectionType = .single(false) //for mandatory selection
 /*or*/collectionView.selectionType = .single(true) // for optional selection
 /*or*/collectionView.selectionType = .signleSection // for multi section

 collectionView.containsHandler = { object1 , object2 in
        return (object1 as? User)?.id == (object2 as? User)?.id
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

- Default placeholder view for (UITableView and for UICollectionView): 
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
- Full Screen loader: 
put this code in App Delegate for show full screen loader for all requests in your app.
```swift
// for full screen loader
RequestBuilder.shared.waitingView { value in
    if value {
        // show loader
        print("loader loaded")
    }else{
        //  dismiss loader
        print("loader dismiss")
    }
}
```
# How used (Webservice and SwiftUI):
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
#Result:
it is very important framework for IOS developers to create IOS project with minimum code.

# Developer's information to communicate

- salahalimohamed1995@gmail.com
- https://www.facebook.com/salah.shaker.7
- +201096710204 (whatsApp And PhoneNumber)
- https://www.linkedin.com/in/salah-mohamed-676b6a17a (Linkedin)
- https://www.upwork.com/freelancers/~01d5d99dadac372b6d (Upwork)

#Note:
i'm searching a part time job if you have opportunity, contact me in linked in or other please.


