//
//  ItemsViewModel.swift
//  GeneralKitExample
//
//  Created by Salah on 10/1/22.
//

import Foundation
import GeneralKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
//https://island-bramble.glitch.me/data?page=1
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
/*
 public var i_per_page: NSNumber?
 public var i_total_pages: NSNumber?
 public var i_total_objects: NSNumber?
 public var i_current_page: NSNumber?
 public var i_items_on_page: NSNumber?
 */
