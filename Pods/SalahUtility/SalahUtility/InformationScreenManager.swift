//
//  InformationScreenManager.swift
//  SalatySalahy
//
//  Created by Salah on 3/17/19.
//  Copyright © 2019 Salah. All rights reserved.
//

public class InformationScreenManager: NSObject {
    public   enum CommitType : Int {
        case manualCommit
        case automaticallyCommit
    }
    public typealias InformationScreenHandler = ()->Void
    public  var informationScreenHandler:InformationScreenHandler?
    
    public  static let sharedInstance: InformationScreenManager = { InformationScreenManager()} ()
    
    public func informationScreenHandler(_ informationScreenHandler:@escaping InformationScreenHandler){
        self.informationScreenHandler=informationScreenHandler;
    }
    var isShowedBefore:Bool{
        set
        {
            UserDefaults.standard.set(newValue, forKey: "isShowedBefore")
        }
        get{
            return UserDefaults.standard.bool(forKey: "isShowedBefore");
        }
    }
    public var commitType:CommitType = .automaticallyCommit;
    public func showInfoScreenHere(_ commitType:CommitType? = .automaticallyCommit)
    {
        self.commitType = commitType!;
        
        if  self.commitType == .automaticallyCommit{
            if  self.informationScreenHandler != nil && isShowedBefore == false{
                self.informationScreenHandler!();
                self.isShowedBefore=true;
            }
        }
        else
            if  self.commitType == .manualCommit{
                if  self.informationScreenHandler != nil && isShowedBefore == false{
                    self.informationScreenHandler!();
                }}
        
    }
    
    override init() {
        super.init()
        
    }
    
    public func commit(){
        self.isShowedBefore=true;
    }
}
