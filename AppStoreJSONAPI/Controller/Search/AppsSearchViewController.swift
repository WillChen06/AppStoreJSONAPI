//
//  AppsSearchViewController.swift
//  AppStoreJSONAPI
//
//  Created by WillChen on 2022/11/5.
//

import UIKit
import Kingfisher

class AppsSearchViewController: BaseListController {
    
    private let cellId = "AppsSearchCell"
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let enterSearchTermLabel: UILabel = {
        let label = UILabel()
        label.text = "Please enter search term above..."
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private var appResults = [Result]()
    
    private var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        collectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.addSubview(enterSearchTermLabel)
        enterSearchTermLabel.fillSuperview(padding: .init(top: 100, left: 50, bottom: 0, right: 50))
    }
    
    private func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }

    private func fetchITunesApps(searchTerm: String) {
        if searchTerm.isEmpty {
            appResults.removeAll()
            collectionView.reloadData()
            return
        }
        Task {
            async let fecthData = Service.shared.fetchApps(searchTerm: searchTerm)
            appResults = await fecthData?.results ?? []
            Task.detached { @MainActor in
                self.collectionView.reloadData()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        enterSearchTermLabel.isHidden = !appResults.isEmpty
        return appResults.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchResultCollectionViewCell
        let appResult = appResults[indexPath.item]
        cell.appResult = appResult
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AppsSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width, height: 350)
    }
}

// MARK: - UISearchBarDelegate
extension AppsSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            print("Text did change: \(searchText)")
            self.fetchITunesApps(searchTerm: searchText)
        }
    }
}
