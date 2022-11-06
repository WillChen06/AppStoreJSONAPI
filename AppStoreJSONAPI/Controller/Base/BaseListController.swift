//
//  BaseListController.swift
//  AppStoreJSONAPI
//
//  Created by WillChen on 2022/11/6.
//

import UIKit

class BaseListController: UICollectionViewController {
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
