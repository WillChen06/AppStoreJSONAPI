//
//  MusicController.swift
//  AppStoreJSONAPI
//
//  Created by WillChen on 2022/11/20.
//

import UIKit

class MusicController: BaseListController {
    private let cellId = "TrackCell"
    private let footerId = "FooterId"
    private let searchTerm = "talyor"
    private var isPaginating = false
    private var isDonePaginating = false
    private var results: [Result] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(TrackCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(MusicLoadingFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
        
        fetchData()
    }
    
    private func fetchData() {
        Task {
            async let fetchTracks = Service.shared.fecthMusicWithOffset(searchTerm: searchTerm, offset: 0)
            self.results = await fetchTracks?.results ?? []

            Task.detached { @MainActor in
                self.collectionView.reloadData()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        results.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TrackCell
        let track = results[indexPath.item]
        cell.nameLabel.text = track.trackName
        cell.imageView.kf.setImage(with: URL(string: track.artworkUrl100))
        cell.subTitleLabel.text = "\(track.artistName ?? "") \(track.collectionName ?? "")"
        
        if indexPath.item == results.count - 1 {
            isPaginating = true
            Task {
                async let fetchTracks = Service.shared.fecthMusicWithOffset(searchTerm: searchTerm, offset: results.count)

                if await fetchTracks?.results.count == 0 {
                    self.isDonePaginating = true
                }
                
                try await Task.sleep(nanoseconds: 2_000_000_000)
                self.results += await fetchTracks?.results ?? []
                
                Task.detached { @MainActor in
                    self.collectionView.reloadData()
                    self.isPaginating = false
                }
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        CGSize(width: view.frame.width, height: isDonePaginating ? 0 : 100)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MusicController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width, height: 100)
    }
}
