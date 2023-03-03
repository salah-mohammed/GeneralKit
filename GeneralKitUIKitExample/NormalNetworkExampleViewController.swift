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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func requestExample1(_ sender:Any){
        RequestOperationBuilder<BaseResponse>.init()
            .baseRequest(NewRequest.init(.firstRequest(s_phone: nil)))
            .build()
            .responseHandler({ response in
            ResponseHandler.check(response, { baseResponse in

            })
        }).execute()
    }
    @IBAction func requestExample2(_ sender:Any){
        RequestOperationBuilder<BaseResponse>.init()
            .baseRequest(NewRequest.init(.firstRequest(s_phone: nil)))
            .build()
            .executeWithCheckResponse { baseResponse in
            
        }
    }
    @IBAction func requestExample3(_ sender:Any){
        RequestOperationBuilder<BaseResponse>.init()
            .encoding(JSONEncoding.default)
            .baseRequest(NewRequest.init(.firstRequest(s_phone: nil)))
            .build().executeWithCheckResponse { baseResponse in
            
        }
    }
    @IBAction func requestMultipart(_ sender:Any){
        RequestOperationBuilder<BaseResponse>.init()
            .multipart(true)
            .baseRequest(NewRequest.init(.multipartRequest(s_phone:nil, image:nil)))
            .build()
            .executeWithCheckResponse { baseResponse in
            
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
