//
//  AppFullscreenController.swift
//  AppStoreJSONAPI
//
//  Created by WillChen on 2022/11/12.
//

import UIKit

class AppFullscreenController: UITableViewController {
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
        
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.contentInsetAdjustmentBehavior = .never
        
        let statusBarFrame = UIApplication.shared.statusBarFrame
        tableView.contentInset = .init(top: 0, left: 0, bottom: statusBarFrame.height, right: 0)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = AppFullscreenHeaderCell()
            cell.closeButton.addTarget(self, action: #selector(dismissFullscreen(_:)), for: .touchUpInside)
            cell.todayCell.todayItem = todayItem
            cell.todayCell.layer.cornerRadius = 0
            return cell
        }
        let cell = AppFullscreenDescriptionCell()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.row == 0 ? 450 : super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    @objc func dismissFullscreen(_ sender: UIButton) {
        sender.isHidden = true
        dismissClosure?()
    }
}
