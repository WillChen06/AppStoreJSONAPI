//
//  TodayItem.swift
//  AppStoreJSONAPI
//
//  Created by WillChen on 2022/11/13.
//

import UIKit

struct TodayItem {
    let category: String
    let title: String
    let image: UIImage
    let description: String
    let backgroundColor: UIColor
    
    let cellType: CellType
    
    var apps: [FeedResult]
    
    enum CellType: String {
        case single, multiple
    }
}

