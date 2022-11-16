//
//  MultipleAppCell.swift
//  AppStoreJSONAPI
//
//  Created by WillChen on 2022/11/15.
//

import UIKit

class MultipleAppCell: UICollectionViewCell {
    
    var app: FeedResult! {
        didSet {
            nameLabel.text = app.name
            companyLabel.text = app.artistName
            imageView.kf.setImage(with: URL(string: app.artworkUrl100))
        }
    }
    
    let imageView: UIImageView = UIImageView(cornerRadius: 8)
    
    let nameLabel: UILabel = UILabel(text: "App Name", font: .systemFont(ofSize: 16))
    let companyLabel: UILabel = UILabel(text: "Company Name", font: .systemFont(ofSize: 13))
    
    let getButton: UIButton = UIButton(title: "GET")
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    
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
        
        addSubview(separatorView)
        separatorView.anchor(top: nil, leading: nameLabel.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: -8, right: 0), size: .init(width: 0, height: 0.5))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
