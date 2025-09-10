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
    @Published  var list:[Post] = []
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
        paginationManager.baseRequest(PostRequest.init(.list));
        self.paginationManager.responseHandler { response in
            ResponseHandler.check(response,{ baseResponse in
                            if self.paginationManager.currentPage == 1{
                                self.list = baseResponse.posts
                            }else{
                                self.list.append(contentsOf: baseResponse.posts)
                            }
            })
        }
        self.paginationManager.start();
    }
}
