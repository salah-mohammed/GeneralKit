//
//  SheetViewController.swift
//  JetrxProject
//
//  Created by Salah on 11/16/21.
//

import Foundation
import UIKit

open class SheetViewController:UIViewController,UITextFieldDelegate{
    var respectSafeArea:Bool{
     return false
    }
    @IBOutlet weak open var stackViewScrollViewContent: UIStackView!
    private var viewKeyboardHeight:UIView?
    @IBOutlet weak var scrollView: UIScrollView?
    var activeField: UITextField?
    open override func viewDidLoad() {
        super.viewDidLoad();
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func calculateHeight(_ keyboardSize:CGRect)->CGFloat{
        return self.respectSafeArea ? keyboardSize.height-self.view.safeAreaInsets.bottom:keyboardSize.height
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if viewKeyboardHeight == nil {
                viewKeyboardHeight = UIView.init();
                if let viewKeyboardHeight:UIView=viewKeyboardHeight{
                viewKeyboardHeight.translatesAutoresizingMaskIntoConstraints = false
                self.stackViewScrollViewContent.addArrangedSubview(viewKeyboardHeight);
                    stackViewScrollViewContent.addConstraint(NSLayoutConstraint(item: viewKeyboardHeight, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,multiplier: 1, constant: self.calculateHeight(keyboardSize)))
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                        if let activeField:UITextField = self.activeField{
                        self.scrollView?.bs_scrollToView(activeField, animated: true);
                        }
                    }
                }
            }
        }
    }
    deinit {
         NotificationCenter.default.removeObserver(self)
       }

    @objc func keyboardWillHide(notification: NSNotification){
        if  viewKeyboardHeight != nil{
            viewKeyboardHeight?.removeFromSuperview();
            viewKeyboardHeight = nil;
        }
    }
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event);
    }
    public func textFieldDidBeginEditing(_ textField: UITextField){
        activeField = textField
    }
    public func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
    }
}

