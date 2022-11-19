//
//  FloatingContainerView.swift
//  AppStoreJSONAPI
//
//  Created by WillChen on 2022/11/19.
//

import UIKit

class FloatingContainerView: UIView {
    let blurVisulEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    
    let imageView: UIImageView = {
        let imageView = UIImageView(cornerRadius: 16)
//        imageView.image = todayItem?.image
        imageView.constrainHeight(constant: 68)
        imageView.constrainWidth(constant: 68)
        return imageView
    }()
    
    let getButton: UIButton = {
        let getButton = UIButton(title: "GET")
        getButton.setTitleColor(.white, for: .normal)
        getButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        getButton.backgroundColor = .darkGray
        getButton.layer.cornerRadius = 16
        getButton.constrainWidth(constant: 80)
        getButton.constrainHeight(constant: 32)
        return getButton
    }()
    
    lazy var stackView = UIStackView(arrangedSubviews: [
        imageView,
        VerticalStackView(arrangedSubviews: [
            UILabel(text: "Life Hack", font: .boldSystemFont(ofSize: 18)),
            UILabel(text: "Utilizing your Time", font: .boldSystemFont(ofSize: 16))
        ], spacing: 4),
        getButton
    ], customSpacing: 16)
    
    convenience init(image: UIImage?) {
        self.init(frame: .zero)
        self.imageView.image = image
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews() {
        clipsToBounds = true
        layer.cornerRadius = 16
        addSubview(blurVisulEffectView)
        addSubview(stackView)
        
        blurVisulEffectView.fillSuperview()
        stackView.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        stackView.alignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
