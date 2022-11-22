//
//  AppRowCollectionViewCell.swift
//  AppStoreJSONAPI
//
//  Created by WillChen on 2022/11/6.
//

import UIKit

class AppRowCollectionViewCell: UICollectionViewCell {
    var app: FeedResult! {
        didSet {
            imageView.kf.setImage(with: URL(string: app.artworkUrl100))
            nameLabel.text = app.name
            companyLabel.text = app.artistName
        }
    }
    
    let imageView: UIImageView = UIImageView(cornerRadius: 8)
    
    let nameLabel: UILabel = UILabel(text: "App Name", font: .systemFont(ofSize: 16))
    let companyLabel: UILabel = UILabel(text: "Company Name", font: .systemFont(ofSize: 13))
    
    let getButton: UIButton = UIButton(title: "GET")
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
    }
    
    private func setupViews() {        
        imageView.backgroundColor = .purple
        imageView.constrainWidth(constant: 64)
        imageView.constrainHeight(constant: 64)
        
        getButton.backgroundColor = UIColor(white: 0.95, alpha: 1)
        getButton.constrainWidth(constant: 80)
        getButton.constrainHeight(constant: 32)
        getButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        getButton.layer.cornerRadius = 32 / 2
        
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            VerticalStackView(arrangedSubviews: [
                nameLabel, companyLabel
            ], spacing: 4),
            getButton])
        stackView.spacing = 16
        stackView.alignment = .center
        
        addSubview(stackView)
        stackView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
