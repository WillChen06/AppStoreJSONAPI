//
//  AppFullscreenController.swift
//  AppStoreJSONAPI
//
//  Created by WillChen on 2022/11/12.
//

import UIKit

class AppFullscreenController: UIViewController {
    let tableView = UITableView(frame: .zero, style: .plain)
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(weight: .heavy)
        button.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: configuration), for: .normal)
        return button
    }()
    
    var dismissClosure: (() -> Void)?
    
    var todayItem: TodayItem?
    
    init(todayItem: TodayItem) {
        self.todayItem = todayItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.clipsToBounds = true
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.contentInsetAdjustmentBehavior = .never
        let statusBarFrame = UIApplication.shared.statusBarFrame
        tableView.contentInset = .init(top: 0, left: 0, bottom: statusBarFrame.height, right: 0)
        
        view.addSubview(tableView)
        tableView.fillSuperview()
        
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 12, left: 0, bottom: 0, right: 0), size: .init(width: 80, height: 40))
        closeButton.addTarget(self, action: #selector(dismissFullscreen), for: .touchUpInside)
    }
        
    @objc func dismissFullscreen(_ sender: UIButton) {
        sender.isHidden = true
        dismissClosure?()
    }
}

// MARK: - UITableView DataSource & Delegate
extension AppFullscreenController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = AppFullscreenHeaderCell()
            cell.todayCell.todayItem = todayItem
            cell.todayCell.layer.cornerRadius = 0
            cell.clipsToBounds = true
            cell.todayCell.backgroundView = nil
            return cell
        }
        let cell = AppFullscreenDescriptionCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.row == 0 ? TodayController.cellSize : UITableView.automaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.isScrollEnabled = false
            scrollView.isScrollEnabled = true
        }
    }
}
