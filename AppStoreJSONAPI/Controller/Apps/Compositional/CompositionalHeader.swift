//
//  CompositionalHeader.swift
//  AppStoreJSONAPI
//
//  Created by WillChen on 2022/11/21.
//

import UIKit

class CompositionalHeader: UICollectionReusableView {
    
    let label = UILabel(text: "Editor's Choise Games", font: .boldSystemFont(ofSize: 32))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
