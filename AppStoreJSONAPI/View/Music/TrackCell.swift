//
//  TrackCell.swift
//  AppStoreJSONAPI
//
//  Created by WillChen on 2022/11/20.
//

import UIKit

class TrackCell: UICollectionViewCell {
    let imageView = UIImageView(cornerRadius: 16)
    let nameLabel = UILabel(text: "Track Name", font: .boldSystemFont(ofSize: 18))
    let subTitleLabel = UILabel(text: "SubtitleLabel", font: .systemFont(ofSize: 16), numberOfLines: 2)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews() {
        imageView.image = UIImage(named: "garden")
        imageView.constrainWidth(constant: 80)
        
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            VerticalStackView(arrangedSubviews: [nameLabel, subTitleLabel], spacing: 4)
        ], customSpacing: 16)
        
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        stackView.alignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
