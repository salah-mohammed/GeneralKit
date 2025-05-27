//
//  RequestBuilderGroup.swift
//  GeneralKit
//
//  Created by SalahMohamed on 01/04/2023.
//

import Foundation
import ObjectMapper
import Alamofire
public class RequestBuilderGroup<T:Mappable>:NSObject{
    public typealias Process = (request:RequestOperationBuilder<T>,handler:RequestOperationBuilder<T>.FinishHandler)
    private var processs = [Process]()
    var current:Int?
    public init(_ processs:[Process]?) {
        if let items: [Process] = processs{
            self.processs = items
        }
    }
    func nextProcess(){
        if let current:Int = self.current{
            if let nextProcesItem:Process = self.processs.bs_get(current+1){
                self.current = current+1
                nextProcesItem.request.execute()
            }
        }
    }
    @discardableResult public func build()->Self{
    for procesItem in processs{
        procesItem.request.responseHandler({ a in
        self.nextProcess()
     procesItem.handler(a)
            
        })
        procesItem.request.build();
    }
    return self
    }
    public func execute(){
        if let procesItem:Process = processs.first{
            procesItem.request.execute()
            current=0
        }
    }
    @discardableResult public func append(_ procesItem:Process)->Self{
        self.processs.append(procesItem)
        return self;
    }
   
}
