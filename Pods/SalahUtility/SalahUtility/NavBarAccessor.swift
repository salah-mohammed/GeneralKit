//
//  NavBarAccessor.swift
//  CrosswordsGame
//
//  Created by SalahMohamed on 19/02/2023.
//

import Foundation
import SwiftUI
@available(iOS 13.0, *)

public struct NavBarAccessor: UIViewControllerRepresentable {
    public var callback: (UINavigationBar) -> Void
    private let proxyController = ViewController()

    public init(_ callback: @escaping (UINavigationBar) -> Void) {
        self.callback = callback
    }
    public func makeUIViewController(context: UIViewControllerRepresentableContext<NavBarAccessor>) ->
                              UIViewController {
        proxyController.callback = callback
        return proxyController
    }

    public func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavBarAccessor>) {
    }

    public typealias UIViewControllerType = UIViewController

    private class ViewController: UIViewController {
        var callback: (UINavigationBar) -> Void = { _ in }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if let navBar = self.navigationController {
                self.callback(navBar.navigationBar)
            }
        }
    }
}
