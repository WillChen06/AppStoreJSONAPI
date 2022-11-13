//
//  TodayCell.swift
//  AppStoreJSONAPI
//
//  Created by WillChen on 2022/11/12.
//

import UIKit

class TodayCell: UICollectionViewCell {
    var todayItem: TodayItem! {
        didSet {
            categoryLabel.text = todayItem.category
            titleLabel.text = todayItem.title
            imageView.image = todayItem.image
            descriptionLabel.text = todayItem.description
            backgroundColor = todayItem.backgroundColor
        }
    }
    
    let categoryLabel = UILabel(text: "LIFE HACK", font: .boldSystemFont(ofSize: 20))
    let titleLabel = UILabel(text: "Utilizing your Time", font: .boldSystemFont(ofSize: 26))
    
    let imageView = UIImageView(image: UIImage(named: "garden"))
    
    let descriptionLabel = UILabel(text: "All the tools and apps you need to intelligently organize your life the right way.", font: .systemFont(ofSize: 18), numberOfLines: 3)
    
    var topConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews() {
        layer.cornerRadius = 16
        clipsToBounds = true
        
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        
        let imageContainerView = UIView()
        imageContainerView.addSubview(imageView)
        imageView.centerInSuperview(size: .init(width: 200, height: 200))
        
        let stackView = VerticalStackView(arrangedSubviews: [
            categoryLabel,
            titleLabel,
            imageContainerView,
            descriptionLabel
        ], spacing: 8)
        descriptionLabel.lineBreakMode = .byClipping
        
        addSubview(stackView)
        stackView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 24, left: 24, bottom: 24, right: 24))
        self.topConstraint = stackView.topAnchor.constraint(equalTo: topAnchor, constant: 24)
        self.topConstraint.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
