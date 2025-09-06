//
//  OffsetUserListViewModel.swift
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
class OffsetUserListViewModel:NSObject,ObservableObject{
    @Published  var list:[User] = []
    var paginationManager:PaginationManager<BaseResponse>=PaginationManager<BaseResponse>.init()
    var paginationResponseHandler:OffsetPaginationResponseHandler
    override init() {
        paginationResponseHandler=OffsetPaginationResponseHandler.init(self.paginationManager);
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
