//
//  VerticallyCenteredTextView.swift
//  SalahUtility
//
//  Created by Salah on 11/21/21.
//  Copyright © 2021 Salah. All rights reserved.
//
#if os(iOS)
import Foundation
import UIKit
public class VerticallyCenteredTextView: UITextView {
    public override var text: String? {
        didSet {
            update();
        }
    }
    public override var attributedText:NSAttributedString!{
        didSet {
            update();
        }
    }
    public override func layoutSubviews() {
        super.layoutSubviews();
        // this for spaces between lines
        self.textContainer.lineFragmentPadding = 0
        // this for padding from top and bottom and left and right
        self.textContainerInset = .zero
    }
    func update(){
        DispatchQueue.main.asyncAfter(deadline: .now()+0.03) {
        self.bs_centerText();
        }
    }
}
#endif
