//
//  HomeViewController.swift
//  WechatMoment
//
//  Created by lieon on 2019/6/14.
//  Copyright © 2019 lieon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    let bag = DisposeBag()
    @IBOutlet weak var tableView: UITableView!
    
    struct UISize {
        static let headerHeight: CGFloat = 667 * 0.5
        
    }
    fileprivate lazy var headerView: HomeHeaderView = {
        let headerView = HomeHeaderView.loadView()
        return headerView
    }()
    
    convenience init(_ viewModel: HomeViewModel) {
        self.init(nibName: "HomeViewController", bundle: nil)
        
        self.rx
            .viewDidLoad
            .subscribe(onNext: { [weak self] in
                self?.configUI()
                self?.config(viewModel)
            })
            .disposed(by: bag)
        
        self.rx
            .viewDidLoad
            .bind(to: viewModel.viewDidLoad)
            .disposed(by: bag)
        
        
    }
    
    fileprivate func config(_ viewModel: HomeViewModel) {
       viewModel.userProfileOutput
            .asObservable()
            .skip(1)
            .bind(to: headerView.rx.userProfile)
            .disposed(by: bag)
    }
    
    
    fileprivate func configUI() {
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        let headerViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UISize.headerHeight))
        headerView.frame = headerViewContainer.bounds
        headerViewContainer.addSubview(headerView)
        tableView.tableHeaderView = headerViewContainer
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

}
