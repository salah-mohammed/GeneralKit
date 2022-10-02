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
    func moreAction(){
        self.paginationManager.loadNextPage();
    }
    func paginationSetup(){
        self.paginationManager.start();
        self.paginationManager.responseHandler { response in
        
        }
    }
}
/*
 public var i_per_page: NSNumber?
 public var i_total_pages: NSNumber?
 public var i_total_objects: NSNumber?
 public var i_current_page: NSNumber?
 public var i_items_on_page: NSNumber?
 */
