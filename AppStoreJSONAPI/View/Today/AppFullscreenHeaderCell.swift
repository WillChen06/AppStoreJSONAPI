//
//  AppFullscreenHeaderCell.swift
//  AppStoreJSONAPI
//
//  Created by WillChen on 2022/11/12.
//

import UIKit

class AppFullscreenHeaderCell: UITableViewCell {
    
    let todayCell = TodayCell()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(weight: .heavy)
        button.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: configuration), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    private func setupViews() {
        contentView.addSubview(todayCell)
        todayCell.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor)
        
        contentView.addSubview(closeButton)
        closeButton.anchor(top: contentView.topAnchor, leading: nil, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: 44, left: 0, bottom: 0, right: 0), size: .init(width: 80, height: 38))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
