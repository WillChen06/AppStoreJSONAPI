//
//  AppCompositionalView.swift
//  AppStoreJSONAPI
//
//  Created by WillChen on 2022/11/21.
//

import SwiftUI

struct AppsView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = CompositionalController()
        return UINavigationController(rootViewController: controller)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}

struct AppCompositionalView_Previews: PreviewProvider {
    static var previews: some View {
        AppsView()
            .ignoresSafeArea()
    }
}
