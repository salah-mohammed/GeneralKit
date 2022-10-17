//
//  SwiftUIControls.swift
//  SalahUtility
//
//  Created by Salah on 6/2/22.
//  Copyright © 2022 Salah. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

@available(iOS 13.0, *)
public struct ActivityIndicator: UIViewRepresentable {

    @Binding public var isAnimating: Bool
    let style: UIActivityIndicatorView.Style
    public init(style:UIActivityIndicatorView.Style,isAnimating:Binding<Bool>) {
        _isAnimating = isAnimating
        self.style = style
     }
    public func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    public func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
@available(iOS 13.0, *)
public struct Anything<Wrapper : UIView>: UIViewRepresentable {
    typealias Updater = (Wrapper, Context) -> Void

    var makeView: () -> Wrapper
    var update: (Wrapper, Context) -> Void

    public init(_ makeView: @escaping @autoclosure () -> Wrapper,
         updater update: @escaping (Wrapper) -> Void) {
        self.makeView = makeView
        self.update = { view, _ in update(view) }
    }

    public func makeUIView(context: Context) -> Wrapper {
        makeView()
    }

    public func updateUIView(_ view: Wrapper, context: Context) {
        update(view, context)
    }
}
