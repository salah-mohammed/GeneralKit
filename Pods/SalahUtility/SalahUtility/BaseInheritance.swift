//
//  BaseInheritance.swift
//  Jobs
//
//  Created by Salah on 11/14/18.
//  Copyright © 2018 Salah. All rights reserved.
//

#if os(iOS)
import Foundation
import UIKit

open class RoundedLabel: UILabel {
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.height / 2.0
    }
}

open class RoundedView: UIView {
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.height / 2.0
    }
}

open class RoundedUIImageView: UIImageView {
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.height / 2.0
    }
}

open class RoundedUIButton: UIButton {
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.height / 2.0
    }
}

open class RoundedStyleView:UIView{
  private var cornerRadiusValue:CGFloat=0.0
  private var rectCorner:UIRectCorner?
  var respectLanguage:Bool=false;
    
    open func respectLanguage(_ respectLanguage:Bool)->Self{
    self.respectLanguage=respectLanguage
    return self
  }
    open func rounded(rectCorner:UIRectCorner,cornerRadius:CGFloat){
    self.rectCorner = rectCorner
    self.cornerRadiusValue = cornerRadius
    self.round()
  }
    open func rounded(cornerRadius:CGFloat){
    self.rectCorner=nil;
    self.cornerRadiusValue = cornerRadius;
    self.round()
  }
    open override func layoutSubviews() {
    super.layoutSubviews();
    self.round()
  }
  private func round(){
    if let rect = self.rectCorner {
        self.respectLanguage ? self.bs_roundCornersRespectLanauge(rect, cornerRadiusValue):self.bs_roundCorners(rect, cornerRadiusValue)
    }else{
      self.layer.cornerRadius = cornerRadiusValue
    }
  }
}
#endif
