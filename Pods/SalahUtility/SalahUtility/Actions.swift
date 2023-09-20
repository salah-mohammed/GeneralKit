//
//  Actions.swift
//  SalahUtility
//
//  Created by SalahMohamed on 28/11/2022.
//  Copyright © 2022 Salah. All rights reserved.
//
#if os(iOS)

import Foundation
import UIKit

final public class Action: BaseAction {
    private let _action: (UIControl) -> ()
    var _control:UIControl
    public init(_ action: @escaping (UIControl) -> (),
                control:UIControl) {
        _control=control
        _action = action
        super.init()
    }
    @objc func action() {
        _action(_control)
    }

}
public extension UIControl{
    func bs_action(_ controlEvents: UIControl.Event,
                   _ actions:inout [BaseAction],
                   _ action:@escaping (UIControl) -> ()) {
        let action = Action.init(action, control:self)
        self.addTarget(action, action:#selector(action.action), for:controlEvents)
        actions.append(action);
}
}
public class BaseAction: NSObject {
    deinit {
        print("deinit")
    }
}
final public class GestureAction: BaseAction {
    var _senderView:UIView?
    var _gesture:UIGestureRecognizer?
    private let _action:(UIView?,UIGestureRecognizer?) -> Void
    public init(_ action: @escaping (UIView?,UIGestureRecognizer?) -> Void,
                gesture:UIGestureRecognizer?,senderView:UIView?) {
        _action = action
        _gesture = gesture
        _senderView = senderView
        super.init()
    }
    @objc func action() {
        _action(_senderView,_gesture)
    }
    deinit {
        print("deinit")
    }
}
public extension UIView{
    func bs_tap(_ actions:inout [BaseAction],
                _ action:@escaping ((UIView?,UIGestureRecognizer?) -> Void)) {
        let gestureAction = GestureAction.init(action, gesture: nil, senderView: self)
        let tapGesture = UITapGestureRecognizer.init(target:gestureAction, action:#selector(gestureAction.action))
        gestureAction._gesture=tapGesture
        self.addGestureRecognizer(tapGesture);
        actions.append(gestureAction);
    }
    func bs_longPress(
        _ actions:inout [BaseAction],
        config:((UILongPressGestureRecognizer)->Void)? = nil,
        _ action:@escaping (UIView?,UIGestureRecognizer?) -> Void){
        let gestureAction = GestureAction.init(action, gesture: nil, senderView: self)
        let longPressGesture = UILongPressGestureRecognizer.init(target:gestureAction, action:#selector(gestureAction.action))
        gestureAction._gesture=longPressGesture
        longPressGesture.addTarget(action, action:#selector(gestureAction.action))
        self.addGestureRecognizer(longPressGesture)
        actions.append(gestureAction);
        config?(longPressGesture);
    }
}
#endif



