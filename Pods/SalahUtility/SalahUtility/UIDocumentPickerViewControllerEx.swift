//
//  UIDocumentPickerViewControllerEx.swift
//  Multe
//
//  Created by Salah on 9/1/18.
//  Copyright © 2018 Newline Tech. All rights reserved.
//
#if os(iOS)
import UIKit

extension  UIDocumentPickerViewController:UIDocumentPickerDelegate{
    typealias bs_FinishHandler = ([URL]) -> Void

    private struct PrivateProperties {
        static var FinishHandler = "bs_FinishHandler"
    }
     var bs_finishHandlerAction:bs_FinishHandler?
    {
        set
        {
            objc_setAssociatedObject(
                self,
                &PrivateProperties.FinishHandler,
                newValue as bs_FinishHandler?,
                objc_AssociationPolicy(rawValue: objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC.rawValue)!)
            
        }
        get{
            let  tempObject:bs_FinishHandler = objc_getAssociatedObject(self, &PrivateProperties.FinishHandler) as! bs_FinishHandler
            
            
            return tempObject;
        }
    }
    @discardableResult func bs_setup() -> UIDocumentPickerViewController {
        self.delegate = self;
        self.modalPresentationStyle = .formSheet

        return self;
    }
    @discardableResult func bs_setFinishHandler(_ bs_finishHandler:@escaping UIDocumentPickerViewController.bs_FinishHandler)->UIDocumentPickerViewController {
        self.bs_finishHandlerAction = bs_finishHandler;
        return self;
    }
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let newUrls = urls.flatMap { (url: URL) -> URL? in
            // Create file URL to temporary folder
            var tempURL = URL(fileURLWithPath: NSTemporaryDirectory())
            // Apend filename (name+extension) to URL
            tempURL.appendPathComponent(url.lastPathComponent)
            do {
                // If file with same name exists remove it (replace file with new one)
                if FileManager.default.fileExists(atPath: tempURL.path) {
                    try FileManager.default.removeItem(atPath: tempURL.path)
                }
                var path = tempURL.path
                let fileExtintion = tempURL.pathExtension
                tempURL.deleteLastPathComponent()
                path = tempURL.path
                let newPath = path + "/\(Int(Date.timeIntervalSinceReferenceDate)).\(fileExtintion)"
                // Move file from app_id-Inbox to tmp/filename
                try FileManager.default.moveItem(atPath: url.path, toPath: newPath)
                return URL(fileURLWithPath: newPath)
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
        if self.bs_finishHandlerAction != nil {
            self.bs_finishHandlerAction!(newUrls)
        }
    }

    
}
#endif
