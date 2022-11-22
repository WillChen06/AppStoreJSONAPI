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
    
    enum AppSection {
        case topSocial
        case free
        case paid
        case twFree
    }
    
    lazy var diffableDataSource: UICollectionViewDiffableDataSource<AppSection, AnyHashable> = .init(collectionView: self.collectionView) { collectionView, indexPath, object in
        if let object = object as? SocialApp {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.appHeaderCellId, for: indexPath) as! AppsHeaderCell
            cell.app = object
            return cell
        } else if let object = object as? FeedResult {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.appCellId, for: indexPath) as! AppRowCollectionViewCell
            cell.app = object
            cell.getButton.addTarget(self, action: #selector(self.handleGet), for: .primaryActionTriggered)
            return cell
        }
        return nil
    }
    
    @objc private func handleGet(button: UIView) {
        var superview = button.superview
        while superview != nil {
            if let cell = superview as? UICollectionViewCell {
                guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                guard let objectClickedOnto = diffableDataSource.itemIdentifier(for: indexPath) else { return }
                
                var snapshot = diffableDataSource.snapshot()
                snapshot.deleteItems([objectClickedOnto])
                diffableDataSource.apply(snapshot)
            }
            superview = superview?.superview
        }
    }
    
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
        setupNavigationItems()
        setupRefreshControl()
        setupDiffableDataSource()
    }
    
    private func setupViews() {
        collectionView.backgroundColor = .systemBackground
        collectionView.register(AppsHeaderCell.self, forCellWithReuseIdentifier: appHeaderCellId)
        collectionView.register(AppRowCollectionViewCell.self, forCellWithReuseIdentifier: appCellId)
        collectionView.register(CompositionalHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        navigationItem.title = "Apps"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupNavigationItems() {
        navigationItem.rightBarButtonItem = .init(title: "Fetch Top Free", style: .plain, target: self, action: #selector(handleFetchTWTopFree))
    }
    
    @objc private func handleFetchTWTopFree() {
        Task {
            async let fetchTWTopFreeApps = Service.shared.fetchTWTopFree()
            let twApps = await fetchTWTopFreeApps
            
            var snapshot = diffableDataSource.snapshot()
            snapshot.insertSections([.twFree], afterSection: .topSocial)
            snapshot.appendItems(twApps?.feed.results ?? [], toSection: .twFree)
            Task.detached { @MainActor in
                self.diffableDataSource.apply(snapshot)
            }
            
        }
    }
    
    private func setupRefreshControl() {
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    @objc private func handleRefresh() {
        collectionView.refreshControl?.endRefreshing()
        
        var snapshot = diffableDataSource.snapshot()
        
        snapshot.deleteSections([.twFree])
        
        diffableDataSource.apply(snapshot)
    }
    
    private func setupDiffableDataSource() {
        collectionView.dataSource = diffableDataSource
        
        diffableDataSource.supplementaryViewProvider = .some({ collectionView, elementKind, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: self.headerId, for: indexPath) as! CompositionalHeader
            let snapshot = self.diffableDataSource.snapshot()
            let object = self.diffableDataSource.itemIdentifier(for: indexPath)
            let section = snapshot.sectionIdentifier(containingItem: object!)!
            
            if section == .free {
                header.label.text = "Top Free"
            } else if section == .paid {
                header.label.text = "Top Paid"
            } else {
                header.label.text = "Top TW Free"
            }
            return header
        })
        
        Task {
            async let fetchSocialApps = Service.shared.fetchSocialApps()
            async let fetchTopFreeApps = Service.shared.fetchTopFree()
            async let fetchTopPaidApps = Service.shared.fetchTopPaid()
            
            let apps = await fetchSocialApps
            let freeApps = await fetchTopFreeApps
            let paidApps = await fetchTopPaidApps
            var snapshot = self.diffableDataSource.snapshot()
            snapshot.appendSections([.topSocial, .free, .paid])
            snapshot.appendItems(apps, toSection: .topSocial)
            snapshot.appendItems(freeApps?.feed.results ?? [], toSection: .free)
            snapshot.appendItems(paidApps?.feed.results ?? [], toSection: .paid)
            Task.detached { @MainActor in
                self.diffableDataSource.apply(snapshot)
            }
        }
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension CompositionalController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appId: String
        let object = diffableDataSource.itemIdentifier(for: indexPath)
        if let object = object as? SocialApp {
            appId = object.id
        } else if let object = object as? FeedResult {
            appId = object.id
        } else {
            appId = ""
        }
        
        let detailController = AppDetailController(appId: appId)
        navigationController?.pushViewController(detailController, animated: true)
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
