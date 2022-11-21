//
//  CompositionalController.swift
//  AppStoreJSONAPI
//
//  Created by WillChen on 2022/11/21.
//

import UIKit

class CompositionalController: UICollectionViewController {
    private let headerId = "HeaderId"
    private let appHeaderCellId = "AppHeaderCellId"
    private let appCellId = "AppRowCellId"
    
    private var socailApps: [SocialApp] = []
    private var topFreeApps: AppGroup?
    
    init() {
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection in
            sectionNumber == 0 ? CompositionalController.topSection() : CompositionalController.appsSection()
        }
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchApps()
    }
    
    private func setupViews() {
        collectionView.backgroundColor = .systemBackground
        collectionView.register(AppsHeaderCell.self, forCellWithReuseIdentifier: appHeaderCellId)
        collectionView.register(AppRowCollectionViewCell.self, forCellWithReuseIdentifier: appCellId)
        collectionView.register(CompositionalHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        navigationItem.title = "Apps"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func fetchApps() {
        Task {
            async let fetchSocialApps = Service.shared.fetchSocialApps()
            async let fetchTopFreeApps = Service.shared.fetchTopFree()
            
            self.socailApps = await fetchSocialApps
            self.topFreeApps = await fetchTopFreeApps
            
            Task.detached { @MainActor in
                self.collectionView.reloadData()
            }
        }
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension CompositionalController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        section == 0 ? socailApps.count : topFreeApps?.feed.results.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: appHeaderCellId, for: indexPath) as! AppsHeaderCell
            let socailApp = socailApps[indexPath.item]
            cell.titleLabel.text = socailApp.tagline
            cell.companyLabel.text = socailApp.name
            cell.imageView.kf.setImage(with: URL(string: socailApp.imageUrl))
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: appCellId, for: indexPath) as! AppRowCollectionViewCell
            let app = topFreeApps?.feed.results[indexPath.item]
            cell.companyLabel.text = app?.artistName
            cell.nameLabel.text = app?.name
            cell.imageView.kf.setImage(with: URL(string: app?.artworkUrl100 ?? ""))
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appId: String
        if indexPath.section == 0 {
            appId = socailApps[indexPath.item].id
        } else {
            appId = topFreeApps?.feed.results[indexPath.item].id ?? ""
        }
        let appDetailController = AppDetailController(appId: appId)
        navigationController?.pushViewController(appDetailController, animated: true)
    }
}

// MARK: - NSCollectionLayoutSection
extension CompositionalController {
    static func topSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets.bottom = 16
        item.contentInsets.trailing = 16
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(300)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets.leading = 16
        return section
    }
    
    static func appsSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1 / 3)))
        item.contentInsets = .init(top: 0, leading: 0, bottom: 16, trailing: 16)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(300)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets.leading = 16
        let kind = UICollectionView.elementKindSectionHeader
        section.boundarySupplementaryItems = [
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: kind, alignment: .topLeading)
        ]
        
        return section
    }
}
