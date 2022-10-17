//
//  File.swift
//  SalahUtility
//
//  Created by Salah on 6/26/21.
//  Copyright © 2021 Salah. All rights reserved.
//

import Foundation
public class IndexingStorageManager :NSObject {
    var savedKey:String!;
    public var objects:[Int]=[Int]();
    public static let shared: IndexingStorageManager = { IndexingStorageManager(savedKey:"savedKey")} ()

    public init(savedKey:String) {
        super.init()
        self.savedKey=savedKey;
        self.pull();
    }
    public func pull(){
        let array = UserDefaults.standard.array(forKey:self.savedKey)  as? [Int] ?? [Int]()
        self.objects = array;
    }
    public func commit(){
        UserDefaults.standard.set(self.objects, forKey:self.savedKey)
        UserDefaults.standard.synchronize();
    }
    public func discard(){
        UserDefaults.standard.set([], forKey:self.savedKey)
        UserDefaults.standard.synchronize();
        self.pull();
    }
    public func isExist(index:Int)->Bool{
    return self.objects.contains(index);
    }
}
