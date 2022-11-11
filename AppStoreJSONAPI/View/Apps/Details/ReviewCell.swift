//
//  ReviewCell.swift
//  AppStoreJSONAPI
//
//  Created by WillChen on 2022/11/10.
//

import UIKit

class ReviewCell: UICollectionViewCell {
    let titleLabel = UILabel(text: "Review Title", font: .boldSystemFont(ofSize: 16))
    
    let authorLabel = UILabel(text: "Author", font: .systemFont(ofSize: 16))
    
    let starsLabel = UILabel(text: "Stars", font: .systemFont(ofSize: 14))
    
    let starStackView: UIStackView = {
        var arrangedSubviews = [UIView]()
        (0..<5).forEach { i in
            let imageView = UIImageView(image: UIImage(systemName: "star.fill"))
            imageView.tintColor = .orange
            imageView.constrainWidth(constant: 24)
            imageView.constrainHeight(constant: 24)
            arrangedSubviews.append(imageView)
        }
        arrangedSubviews.append(UIView())
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        return stackView
    }()
    
    let bodyLabel = UILabel(text: "Review body\nReview body", font: .systemFont(ofSize: 14), numberOfLines: 5)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = .systemGray5
        
        layer.cornerRadius = 16
        clipsToBounds = true
        
        let stackView = VerticalStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [
                titleLabel, authorLabel
            ], customSpacing: 8),
            starStackView,
            bodyLabel
        ], spacing: 12)
        
        titleLabel.setContentCompressionResistancePriority(.init(rawValue: 0), for: .horizontal)
        addSubview(stackView)
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 20, left: 20, bottom: 0, right: 20))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
