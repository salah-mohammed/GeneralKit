//
//  NormalNetworkExampleViewController.swift
//  GeneralKitUIKitExample
//
//  Created by SalahMohamed on 03/03/2023.
//

import UIKit
import GeneralKit
import Alamofire
class NormalNetworkExampleViewController: UIViewController {
    var requestOperationExample1:RequestOperationBuilder<BaseResponse>?
    var requestOperationExample2:RequestOperationBuilder<BaseResponse>?
    var requestOperationExample3:RequestOperationBuilder<BaseResponse>?
    var requestOperationExample4:RequestOperationBuilder<BaseResponse>?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    deinit{
        print("deinit");
    }
    @IBAction func requestExample1(_ sender:Any){
        self.requestOperationExample1 = RequestOperationBuilder<BaseResponse>.init()
        self.requestOperationExample1?.baseRequest(NewRequest.init(.firstRequest(s_phone: nil)))
            .build()
            .responseHandler({ response in
            ResponseHandler.check(response, { baseResponse in
                print(baseResponse);
            })
        }).execute()
    }
    @IBAction func requestExample2(_ sender:Any){
        self.requestOperationExample2 = RequestOperationBuilder<BaseResponse>.init()
        self.requestOperationExample2?.baseRequest(NewRequest.init(.firstRequest(s_phone: nil)))
            .build()
            .executeWithCheckResponse { baseResponse in
            
        }
    }
    @IBAction func requestExample3(_ sender:Any){
//        self.requestOperationExample3 = RequestOperationBuilder<BaseResponse>.init()
//        self.requestOperationExample3?.baseRequest(NewRequest.init(.firstRequest(s_phone: nil)))
//            .encoding(JSONEncoding.default)
//            .build().executeWithCheckResponse { baseResponse in
//
//        }
    }
    @IBAction func requestMultipart(_ sender:Any){
        self.requestOperationExample4 = RequestOperationBuilder<BaseResponse>.init()
        self.requestOperationExample4?.multipart(true)
            .baseRequest(NewRequest.init(.multipartRequest(s_phone:nil, image:nil)))
            .build()
            .executeWithCheckResponse { baseResponse in
            print(baseResponse)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
