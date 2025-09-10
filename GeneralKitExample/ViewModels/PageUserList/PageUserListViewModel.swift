//
//  PageUserListViewModel.swift
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
class PageUserListViewModel:NSObject,ObservableObject{
    @Published  var list:[User] = []
    var paginationManager:PaginationManager<BaseResponse>=PaginationManager<BaseResponse>.init()
    var paginationResponseHandler:PagePaginationResponseHandler
    override init() {
        paginationResponseHandler=PagePaginationResponseHandler.init(self.paginationManager);
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
                if self.paginationManager.currentPage == 1{
                    self.list = baseResponse.users
                }else{
                    self.list.append(contentsOf: baseResponse.users)
                }
            })

        }
        self.paginationManager.start();
    }
}
