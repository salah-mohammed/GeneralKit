//
//  RequestBuilderGroup.swift
//  GeneralKit
//
//  Created by SalahMohamed on 01/04/2023.
//

import Foundation
import ObjectMapper
import Alamofire
public class RequestBuilderGroup<T:Mappable>:NSObject,ObservableObject{
    public typealias Process = (request:RequestOperationBuilder<T>,handler:RequestOperationBuilder<T>.FinishHandler)
    public var finishHandler:(()->Void)?
    private var processs = [Process]()
    var current:Int?
    @Published public var isLoading:Bool=false
    public init(_ processs:[Process]?) {
        if let items: [Process] = processs{
            self.processs = items
        }
    }
    private func executeNextProcess(){
        if let current:Int = self.current{
            if let nextProcesItem:Process = self.processs.bs_get(current+1){
                self.current = current+1
                nextProcesItem.request.execute()
            }else{
                self.isLoading=false;
                finishHandler?();
            }
        }
    }
    @discardableResult public func build()->Self{
    for procesItem in processs{
        procesItem.request.responseHandler({ a in
        procesItem.handler(a)
        self.executeNextProcess()
        })
        procesItem.request.build();
    }
    return self
    }
    public func execute(){
        if let procesItem:Process = processs.first{
            self.isLoading=true;
            procesItem.request.execute()
            current=0
        }
    }
    @discardableResult public func append(_ procesItem:Process)->Self{
        self.processs.append(procesItem)
        return self;
    }
   
}
