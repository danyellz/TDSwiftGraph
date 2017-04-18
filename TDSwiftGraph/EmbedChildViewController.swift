//
//  EmbedChildViewController.swift
//  TDSwiftGraph
//
//  Created by Tieshow Daniels on 4/17/17.
//  Copyright © 2017 Ty Daniels. All rights reserved.
//

import Foundation
import UIKit

struct EmbedChildViewController {
    static func embed(
        viewControllerId: UIViewController,
        containerViewController: UIViewController,
        containerView: UIView) {
        
        containerViewController.addChildViewController(viewControllerId)
        containerViewController.view.translatesAutoresizingMaskIntoConstraints = true
        containerView.addSubview(viewControllerId.view)
        
        NSLayoutConstraint.activate([
            viewControllerId.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            viewControllerId.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            viewControllerId.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            viewControllerId.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            ])
        
        viewControllerId.preferredContentSize = CGSize(width: containerView.frame.size.width, height: containerView.frame.size.height)
        
        viewControllerId.didMove(toParentViewController: containerViewController)
    }
}
