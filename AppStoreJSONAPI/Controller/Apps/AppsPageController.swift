//
//  AppsPageController.swift
//  AppStoreJSONAPI
//
//  Created by WillChen on 2022/11/6.
//

import UIKit

class AppsPageController: BaseListController {
    let cellId = "AppsCollectionCell"
    let headerId = "AppsHeaderCell"
    
    var groups: [AppGroup] = []
    let urls: [String] = [
        "https://rss.applemarketingtools.com/api/v2/jp/apps/top-free/50/apps.json",
        "https://rss.applemarketingtools.com/api/v2/jp/apps/top-paid/50/apps.json",
        "https://rss.applemarketingtools.com/api/v2/tw/apps/top-free/50/apps.json",
        //"https://rss.applemarketingtools.com/api/v2/tw/apps/top-paid/50/apps.json"
    ]
    
    var socailApps: [SocialApp] = []
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.color = .black
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchData()
    }
    
    private func setupViews() {
        collectionView.register(AppsGroupCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.register(AppsPageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        view.addSubview(activityIndicatorView)
        activityIndicatorView.fillSuperview()
    }
    
    private func fetchData() {
        Task {
            async let fetchGroups = Service.shared.fetchAppsGroup(from: urls)
            async let fetchSocailApps = Service.shared.fetchSocialApps()
            
            self.groups = await fetchGroups
            self.socailApps = await fetchSocailApps
             
            Task.detached { @MainActor in
                self.activityIndicatorView.stopAnimating()
                self.collectionView.reloadData()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! AppsPageHeader
        header.appHeaderHorizontalController.socialApps = self.socailApps
        header.appHeaderHorizontalController.collectionView.reloadData()
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: view.frame.width, height: 300)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        groups.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppsGroupCollectionViewCell
        
        let appGroup = groups[indexPath.item]
        
        
        cell.titleLabel.text = appGroup.feed.title
        cell.horizontalController.appGroup = appGroup
        cell.horizontalController.collectionView.reloadData()
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AppsPageController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
    }
}
