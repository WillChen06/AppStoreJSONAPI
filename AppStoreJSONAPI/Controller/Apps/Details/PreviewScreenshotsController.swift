//
//  PreviewScreenshotsController.swift
//  AppStoreJSONAPI
//
//  Created by WillChen on 2022/11/10.
//

import UIKit

class PreviewScreenshotsController: HorizontalSnappingController {
    class ScreenshotCell: UICollectionViewCell {
        let imageView = UIImageView(cornerRadius: 12)
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            imageView.backgroundColor = .purple
            addSubview(imageView)
            imageView.fillSuperview()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    let cellId = "PreviewScreenShotsCellId"
    
    var app: Result? {
        didSet {
            collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(ScreenshotCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        app?.screenshotUrls?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ScreenshotCell
        let screenshotUrl = self.app?.screenshotUrls?[indexPath.item]
        cell.imageView.kf.setImage(with: URL(string: screenshotUrl ?? ""))
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PreviewScreenshotsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 250, height: view.frame.height)
    }
}
