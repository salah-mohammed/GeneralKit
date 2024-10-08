//
//  ListPlaceHolderView.swift
//  Test12
//
//  Created by Salah on 12/1/18.
//  Copyright © 2018 Salah. All rights reserved.
//
#if os(iOS)

import UIKit
public var ErrorConnection:ListPlaceHolderData{
    let data = ListPlaceHolderData.init()
     data.title("ErrorConnection")
    .contentDescription("ErrorConnection")
    .titleColor(UIColor.black)
    .contentDescriptionColor(UIColor.black)
    .placeHolderType(.errorConnection)
    return data;
}
public var EmptyData:ListPlaceHolderData{
    let data = ListPlaceHolderData.init()
    data.title("EmptyData")
   .contentDescription("EmptyData")
   .titleColor(UIColor.black)
   .contentDescriptionColor(UIColor.black)
   .placeHolderType(.empty)
    return data;
}
public var LoadingData:ListPlaceHolderData{
    let data = ListPlaceHolderData.init()
    data.title("LoadingData")
   .contentDescription("LoadingData")
   .titleColor(UIColor.black)
   .contentDescriptionColor(UIColor.black)
   .placeHolderType(.loading)
    return data;
}
open class ListPlaceHolderData:NSObject{
    enum PlaceHolderType {
        case errorConnection
        case empty
        case loading
    }
    var title:String?
    var titleColor:UIColor?
    
    var contentDescription:String?
    var contentDescriptionColor:UIColor?
    
    var refreshTitle:String?
    var refreshTitleColor:UIColor?
    var refreshImage:UIImage?
    var enableHideImage:Bool?
    var placeHolderType:PlaceHolderType?

    override init() {
        super.init();
    }
    @discardableResult func title(_ title:String) -> Self{
        self.title = title;
        return self;
    }
    @discardableResult func titleColor(_ titleColor:UIColor) -> Self{
        self.titleColor = titleColor;
        return self;
    }
    @discardableResult func contentDescription(_ contentDescription:String) -> Self{
        self.contentDescription = contentDescription;
        return self;
    }
    @discardableResult func contentDescriptionColor(_ contentDescriptionColor:UIColor) -> Self{
        self.contentDescriptionColor = contentDescriptionColor;
        return self;
    }
    @discardableResult func refreshTitle(_ refreshTitle:String) -> Self{
        self.refreshTitle = refreshTitle;
        return self;
    }
    @discardableResult func refreshTitleColor(_ refreshTitleColor:UIColor) -> Self{
        self.refreshTitleColor = refreshTitleColor;
        return self;
    }
    @discardableResult func refreshImage(_ refreshImage:UIImage) -> Self{
        self.refreshImage = refreshImage;
        return self;
    }
    @discardableResult func enableHideImage(_ enableHideImage:Bool) -> Self{
        self.enableHideImage = enableHideImage;
        return self;
    }
    @discardableResult func placeHolderType(_ placeHolderType:PlaceHolderType) -> Self{
        self.placeHolderType = placeHolderType;
        return self;
    }
}
open class ListPlaceHolderView: UIView,ListPlaceHolder {
    public var list: GeneralListViewProrocol?

    public var data:ListPlaceHolderData?{
        didSet{
            self.setupView(data: data);
        }
    }
    @IBInspectable var refreshImage: UIImage? {
        get {
            return self.btnRefresh?.image(for: .normal);
        }
        set {
            self.btnRefresh?.setImage(newValue, for: .normal);
        }
    }

    @IBInspectable var titleColor: UIColor?{
        get {
            return self.lblTitle.textColor;
        }
        set {
            self.lblTitle.textColor = newValue;
        }
    }
    @IBInspectable var title: String? {
        get {
            return self.lblTitle.text;
        }
        set {
            self.lblTitle.text = newValue;
        }
    }
    @IBInspectable var contentDescription: String? {
        get {
            return self.lblContentDescription.text
        }
        set {
            self.lblContentDescription.text = newValue;
        }
    }
    @IBInspectable var contentDescriptionColor: UIColor? {
        get {
            return self.lblContentDescription.textColor
        }
        set {
            self.lblContentDescription.textColor = newValue;
        }
    }

    @IBOutlet var btnRefresh : UIButton?
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContentDescription: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }

    func xibSetup(){
        self.setupView();
    }

    func setupView(){
        if self.data != nil {
        self.setupView(data:self.data)
        }
    }

    public class func loadViewFromNib() -> ListPlaceHolderView {

        let myView = Bundle.module?.loadNibNamed("ListPlaceHolderView", owner:nil, options: nil)![0] as! ListPlaceHolderView

        return myView;

    }
    private func setupView(data:ListPlaceHolderData?){
        self.lblTitle.text=data?.title;
        self.lblTitle.textColor=data?.titleColor;
        self.btnRefresh?.setImage(data?.refreshImage, for: .normal);
        self.btnRefresh?.setTitle(data?.refreshTitle, for: .normal);
        self.btnRefresh?.setTitleColor(data?.refreshTitleColor, for: .normal);
        self.lblContentDescription.text=data?.contentDescription;
        self.lblContentDescription.textColor=data?.contentDescriptionColor;
        self.btnRefresh?.isHidden = !((data?.enableHideImage) ?? true);

    }
    @IBAction func btnRefresh(_ sender: Any) {
        self.list?.start();
    }

}
#endif
