//
//  TodayController.swift
//  AppStoreJSONAPI
//
//  Created by WillChen on 2022/11/12.
//

import UIKit

class TodayController: BaseListController {
    var startingFrame: CGRect?
    
    var appFullscreenController: AppFullscreenController!

    var anchoredConstraints: AnchoredConstraints?
    static let cellSize: CGFloat = 450
    
    var items: [TodayItem] = []
    
    var appFullscreenBeginOffset: CGFloat = 0
    
    var activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.color = .darkGray
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.superview?.setNeedsLayout()
    }
    
    private func setupViews() {
        view.addSubview(blurVisualEffectView)
        blurVisualEffectView.fillSuperview()
        blurVisualEffectView.alpha = 0
        
        navigationController?.isNavigationBarHidden = true
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerInSuperview()
        
        collectionView.backgroundColor = .systemGray6
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayItem.CellType.single.rawValue)
        collectionView.register(TodayMultipleAppCell.self, forCellWithReuseIdentifier: TodayItem.CellType.multiple.rawValue)
    }
    
    private func fetchData() {
        var topFreeGroup: AppGroup?
        var topPaidGroup: AppGroup?
        Task {
            async let fetchFree = Service.shared.fetchTopFree()
            async let fetchPaid = Service.shared.fetchTopPaid()
            
            topFreeGroup = await fetchFree
            topPaidGroup = await fetchPaid
            Task.detached { @MainActor in
                self.activityIndicatorView.stopAnimating()
                self.items = [
                    TodayItem.init(category: "THE DALIY LIST", title: topFreeGroup?.feed.title ?? "", image: UIImage(named: "garden")!, description: "", backgroundColor: .white, cellType: .multiple, apps: topFreeGroup?.feed.results ?? []),
                    TodayItem.init(category: "THE DALIY LIST", title: topPaidGroup?.feed.title ?? "", image: UIImage(named: "garden")!, description: "", backgroundColor: .white, cellType: .multiple, apps: topPaidGroup?.feed.results ?? []),
                    TodayItem.init(category: "LIFE HACK", title: "Utilizing your Time", image: UIImage(named: "garden")!, description: "All the tools and apps you need to intelligently organize your life the right way.", backgroundColor: .white, cellType: .single, apps: []),
                    TodayItem.init(category: "LIFE HACK", title: "Utilizing your Time", image: UIImage(named: "holiday")!, description: "All the tools and apps you need to intelligently organize your life the right way.", backgroundColor: UIColor(named: "holidayYellow") ?? .systemYellow, cellType: .single, apps: [])
                ]
                self.collectionView.reloadData()
            }
        }
        
    }
}

// MARK: - CollectionView Datasource & Delegate
extension TodayController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.cellType.rawValue, for: indexPath) as! BaseTodayCell
        cell.todayItem = item
        (cell as? TodayMultipleAppCell)?.multipleAppsController.collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMultipleApssTap)))
        return cell
    }
    
    @objc private func handleMultipleApssTap(gesture: UIGestureRecognizer) {
        if gesture.state == .began {
            appFullscreenBeginOffset = appFullscreenController.tableView.contentOffset.y
        }
        let collectionView = gesture.view
        var superview = collectionView?.superview
        
        while superview != nil {
            if let cell = superview as? TodayMultipleAppCell {
                guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                showDailyListFullscreen(indexPath: indexPath)
                return
            }
            superview = superview?.superview
        }
    }
    
    private func showDailyListFullscreen(indexPath: IndexPath) {
        let fullController = TodayMultipleAppsController(mode: .fullscreen)
        fullController.apps = self.items[indexPath.item].apps
        let nav = BackEnableNavigationController(rootViewController: fullController)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch items[indexPath.item].cellType {
        case .multiple:
            showDailyListFullscreen(indexPath: indexPath)
        default:
            showSingleFullscreen(indexPath: indexPath)
        }
    }
    
    private func setupSingleAppFullscreenController(_ indexPath: IndexPath) {
        let appFullscreenController = AppFullscreenController(todayItem: items[indexPath.item])
        appFullscreenController.dismissClosure = {
            self.handleAppFullscreenDismissal()
        }
        appFullscreenController.view.layer.cornerRadius = 16
        self.appFullscreenController = appFullscreenController
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag))
        gesture.delegate = self
        appFullscreenController.view.addGestureRecognizer(gesture)
    }
    
    
    
    @objc func handleDrag(gesture: UIPanGestureRecognizer) {
        if appFullscreenController.tableView.contentOffset.y > 0 { return }
        
        let translationY = gesture.translation(in: appFullscreenController.view).y
        if translationY < 0 { return }
        if gesture.state == .changed {
            let trueOffset = translationY - appFullscreenBeginOffset
            var scale = 1 - trueOffset / 1000
            
            scale = max(0.5, scale)
            
            let transform: CGAffineTransform = .init(scaleX: scale, y: scale)
            self.appFullscreenController.view.transform = transform
        } else if gesture.state == .ended {
            handleAppFullscreenDismissal()
        }
    }
    
    private func setupStartingCellFrame(_ indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        self.startingFrame = startingFrame
    }
    
    private func setupAppFullscreenStartingPosition(_ indexPath: IndexPath) {
        let fullscreenView = appFullscreenController.view!
        view.addSubview(fullscreenView)
        
        addChild(appFullscreenController)

        self.collectionView.isUserInteractionEnabled = false
        
        setupStartingCellFrame(indexPath)
        
        guard let startingFrame = self.startingFrame else { return }
        
        self.anchoredConstraints = fullscreenView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: startingFrame.origin.y, left: startingFrame.origin.x, bottom: 0, right: 0), size: .init(width: startingFrame.width, height: startingFrame.height))
        
        
        self.view.layoutIfNeeded()
    }
    
    private func beginAnimationAppFullscreen() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.blurVisualEffectView.alpha = 1
            
            self.anchoredConstraints?.top?.constant = 0
            self.anchoredConstraints?.leading?.constant = 0
            self.anchoredConstraints?.width?.constant = self.view.frame.width
            self.anchoredConstraints?.height?.constant = self.view.frame.height
            
            self.view.layoutIfNeeded()

            self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height
            
            guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }
            cell.todayCell.topConstraint.constant = 48
            cell.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    private func showSingleFullscreen(indexPath: IndexPath) {
        setupSingleAppFullscreenController(indexPath)
        
        setupAppFullscreenStartingPosition(indexPath)
        
        beginAnimationAppFullscreen()
    }
    
    @objc func handleAppFullscreenDismissal() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.blurVisualEffectView.alpha = 0
            self.appFullscreenController.view.transform = .identity
            
            guard let startingFrame = self.startingFrame else {
                return
            }
            
            self.anchoredConstraints?.top?.constant = startingFrame.origin.y
            self.anchoredConstraints?.leading?.constant = startingFrame.origin.x
            self.anchoredConstraints?.width?.constant = startingFrame.width
            self.anchoredConstraints?.height?.constant = startingFrame.height
            
            self.view.layoutIfNeeded()
            
            self.appFullscreenController.tableView.contentOffset = .zero
            if let tabBarFrame = self.tabBarController?.tabBar.frame {
                self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height - tabBarFrame.height
            }
            
            guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }
            cell.closeButton.alpha = 0
            cell.todayCell.topConstraint.constant = 24
            cell.layoutIfNeeded()
            
        }, completion: { _ in
            self.appFullscreenController.view?.removeFromSuperview()
            self.appFullscreenController.removeFromParent()
            self.collectionView.isUserInteractionEnabled = true
        })
    }
}

extension TodayController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width - 64, height: TodayController.cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        32
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 32, left: 0, bottom: 32, right: 0)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension TodayController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
