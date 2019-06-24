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
import RxDataSources
import RxSwiftExt
import PKHUD

class HomeViewController: UIViewController {
    let bag = DisposeBag()
    @IBOutlet weak var titlleLabel: UILabel!
    @IBOutlet weak var navHeight: NSLayoutConstraint!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var tableView: UITableView!
    let tweetList: BehaviorRelay<[Tweet]> = BehaviorRelay(value: [])
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
    
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Tweet>>(
            configureCell: { (_, tableView, indexPath, item) -> UITableViewCell in
                if item.content != nil, item.images != nil {
                    let cell = tableView.dequeueCell(TweetTableViewCell.self, for: indexPath)
                    cell.selectionStyle = .none
                    cell.config(item)
                    return cell
                } else if item.content != nil, item.images == nil {
                    let cell = tableView.dequeueCell(TweetTableViewOnlyTextCell.self, for: indexPath)
                    cell.selectionStyle = .none
                    cell.config(item)
                     return cell
                } else if item.content == nil, item.images != nil {
                    let cell = tableView.dequeueCell(TweetTableViewOnlyImageCell.self, for: indexPath)
                    cell.config(item)
                    cell.selectionStyle = .none
                    return cell
                } else if item.content == nil, item.images == nil, item.sender != nil {
                    let cell = tableView.dequeueCell(TweetTableViewOnlySenderCell.self, for: indexPath)
                    cell.config(item)
                    cell.selectionStyle = .none
                    return cell
                }
                let defaultCell = tableView.dequeueCell(UITableViewCell.self, for: indexPath)
                defaultCell.contentView.backgroundColor = UIColor.red
                return defaultCell
            }
        )
        
        viewModel.sectionDataDriver
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        viewModel.currentTweetList
            .asObservable()
            .bind(to: tweetList)
            .disposed(by: bag)
        
        let momentRefresh = MomentRefreshView.loadView(with: CGPoint(x: 20, y: 45))
        momentRefresh.configScrollView(tableView)
        view.addSubview(momentRefresh)
        view.bringSubviewToFront(momentRefresh)
        
        momentRefresh.refreshAction = {
             viewModel.refreshInput.on(.next(true))
        }
        
        tableView.mj_footer = RefreshFooter(refreshingBlock: {
            viewModel.refreshInput.on(.next(false))
        })
        
        viewModel.laodingDriver
            .asDriver(onErrorJustReturn: false)
            .drive(HUD.loading)
            .disposed(by: bag)
        
        viewModel.refreshStatus
            .bind(to: tableView.rx.mj_RefreshStatus)
            .disposed(by: bag)

        viewModel.refreshStatus
            .bind(to: momentRefresh.rx.momentHeaderRefreshStatus)
            .disposed(by: bag)
        
        viewModel.currentTweetList
            .map { $0.isEmpty}
            .bind(to: tableView.rx.isHidden)
            .disposed(by: bag)
    }
    
    
    fileprivate func configUI() {
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        navHeight.constant = UIDevice.current.isiPhoneXSeries ? 44 + 44: 64
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        let headerViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UISize.headerHeight))
        headerView.frame = headerViewContainer.bounds
        headerViewContainer.addSubview(headerView)
        tableView.tableHeaderView = headerViewContainer
        tableView.registerNibWithCell(TweetTableViewCell.self)
        tableView.registerClassWithCell(UITableViewCell.self)
        tableView.registerNibWithCell(TweetTableViewOnlyImageCell.self)
        tableView.registerNibWithCell(TweetTableViewOnlyTextCell.self)
        tableView.registerNibWithCell(TweetTableViewOnlySenderCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let navBarHegiht: CGFloat = UIDevice.current.isiPhoneXSeries ? 44 + 44: 44 + 20
     /*
         x headerHeight - navBarHegigt  x headerHeight
         y 0  1
         y = kx => k = y/x = headerHeight
         */
        let b = 1.0 / ( UISize.headerHeight -  (UISize.headerHeight - navBarHegiht)) * (UISize.headerHeight - scrollView.contentOffset.y - navBarHegiht)
        if b <= 1 {
            let alpha = 1 - b
            navView.alpha = alpha
            print("scrollViewDidScroll:\(scrollView.contentOffset.y) - alpha: \(alpha)")
        } else {
            navView.alpha = 0
        }
      
    }
}
