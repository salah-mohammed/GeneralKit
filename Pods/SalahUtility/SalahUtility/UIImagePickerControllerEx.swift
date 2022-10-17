//
//  UIImagePickerControllerEx.swift
//  SalahUtility
//
//  Created by Salah on 3/22/21.
//  Copyright © 2021 Salah. All rights reserved.

//
#if os(iOS)
import Foundation
import UIKit
import MobileCoreServices
extension UIImagePickerController:UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    public typealias bs_ImageFinishHandler = (UIImage,[UIImagePickerController.InfoKey : Any]) -> Void
    public typealias bs_VideoFinishHandler = (URL,[UIImagePickerController.InfoKey : Any]) -> Void
    public typealias bs_CancelHandler = (UIImagePickerController) -> Void

     struct PrivateProperties {
        static var ImageFinishHandler = "bs_ImageFinishHandler"
        static var ImageVideoHandler = "bs_VideoFinishHandler"
        static var CancelHandler = "bs_CancelHandler"
    }
     public var bs_finishImageHandlerAction:bs_ImageFinishHandler?
    {
        set
        {
            objc_setAssociatedObject(
                self,
                &PrivateProperties.ImageFinishHandler,
                newValue as bs_ImageFinishHandler?,
                objc_AssociationPolicy(rawValue: objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC.rawValue)!)

        }
        get{
            let  tempObject:bs_ImageFinishHandler = objc_getAssociatedObject(self, &PrivateProperties.ImageFinishHandler) as! bs_ImageFinishHandler


            return tempObject;
        }
    }
    public var bs_finishVideoHandlerAction:bs_VideoFinishHandler?
   {
       set
       {
           objc_setAssociatedObject(
               self,
            &PrivateProperties.ImageVideoHandler,
               newValue as bs_VideoFinishHandler?,
               objc_AssociationPolicy(rawValue: objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC.rawValue)!)

       }
       get{
        let  tempObject:bs_VideoFinishHandler = objc_getAssociatedObject(self, &PrivateProperties.ImageVideoHandler) as! bs_VideoFinishHandler


           return tempObject;
       }
   }
    var bs_cancelHandler:bs_CancelHandler?
   {
       set
       {
           objc_setAssociatedObject(
               self,
               &PrivateProperties.CancelHandler,
               newValue as bs_CancelHandler?,
               objc_AssociationPolicy(rawValue: objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC.rawValue)!)

       }
       get{
           let  tempObject:bs_CancelHandler = objc_getAssociatedObject(self, &PrivateProperties.CancelHandler) as! bs_CancelHandler


           return tempObject;
       }
   }
    @discardableResult public func bs_setup() -> UIImagePickerController {
        self.delegate = self;
        self.modalPresentationStyle = .formSheet
        return self;
    }
    public func bs_present(_ presenter:UIViewController)->Self{
        presenter.present(self, animated: true, completion: nil);
        return self;
    }
    @discardableResult public func bs_setImageFinishHandler(_ bs_finishHandler:@escaping UIImagePickerController.bs_ImageFinishHandler)->Self {
        self.bs_finishImageHandlerAction = bs_finishHandler;
        return self;
    }
    @discardableResult public func bs_setVideoFinishHandler(_ bs_finishHandler:@escaping UIImagePickerController.bs_VideoFinishHandler)->Self {
        self.bs_finishVideoHandlerAction = bs_finishHandler;
        return self;
    }
    @discardableResult public func bs_setCancelHandler(_ bs_cancelHandler:@escaping UIImagePickerController.bs_CancelHandler)->Self {
        self.bs_cancelHandler = bs_cancelHandler;
        return self;
    }
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.bs_cancelHandler?(self);
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true) {
            let mediaType: String = info[UIImagePickerController.InfoKey.mediaType] as! String
            if mediaType == kUTTypeImage as String {
                var imageToSave: UIImage
                if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                    imageToSave = editedImage
                } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    imageToSave = originalImage
                }else{
                    self.bs_cancelHandler?(self);
                    return;
                }
                self.bs_finishImageHandlerAction?(imageToSave,info)
            }else if mediaType == kUTTypeMovie as String,
                     let url:URL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                    self.bs_finishVideoHandlerAction?(url, info)
                }else{
                    self.bs_cancelHandler?(self);
                    return;
                }
        }

    }
}
#endif
