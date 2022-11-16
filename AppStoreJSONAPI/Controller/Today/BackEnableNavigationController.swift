//
//  BackEnableNavigationController.swift
//  AppStoreJSONAPI
//
//  Created by WillChen on 2022/11/15.
//

import UIKit

class BackEnableNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.interactivePopGestureRecognizer?.delegate = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        self.viewControllers.count > 1
    }
}
