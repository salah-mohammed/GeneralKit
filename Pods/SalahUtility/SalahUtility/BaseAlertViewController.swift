//
//  BaseAlertViewController.swift
//  SalahUtility
//
//  Created by SalahMohamed on 21/10/2022.
//  Copyright © 2022 Salah. All rights reserved.
//
#if os(iOS)
import Foundation
import UIKit
open class BaseAlertViewController:UIViewController{
    open override func viewDidLoad() {
        super.viewDidLoad();
        self.view.backgroundColor=UIColor.clear
        setupAlert();
    }
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.backgroundColor=UIColor.black.withAlphaComponent(0.65)
    }
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        self.view.backgroundColor=UIColor.clear
    }
    public func setupAlert(){
        if #available(iOS 13.0, *) {
            self.isModalInPresentation=false
        }
        self.modalPresentationStyle = .overCurrentContext
    }
}
#endif
