//
//  ViewController.swift
//  Rx_assignment_clone
//
//  Created by SeoDongyeon on 2021/11/09.
//

import UIKit
import ReactorKit
import RxSwift
import RxAppState
import SnapKit

class HomeListViewController: UIViewController, View {

    typealias Reactor = HomeListViewReactor
    
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    
    var disposeBag = DisposeBag()
    
    init(reactor: Reactor) {
        defer { self.reactor = reactor }
        super.init(nibName: nil, bundle: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    private func setUp() {
        navigationController?.navigationBar.topItem?.title = "홈"
        
        view.addSubview(tableView)
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.register(cellClass: HomeListBannerCell.self)
        tableView.register(cellClass: HomeListProductCell.self)
        tableView.refreshControl = refreshControl
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bind(reactor: Reactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: Reactor) {
        rx.viewDidLoad
            .map { Reactor.Action.initialFetch }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx.loadMore
            .map { Reactor.Action.loadMore }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .map { Reactor.Action.pullToRefresh}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isRefreshing }
            .distinctUntilChanged()
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: Reactor) {
        reactor.state.map { $0.listSection }
            .distinctUntilChanged()
            .subscribe(onNext: { [ weak tableView] product in
                tableView?.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension HomeListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return HomeListSectionIndex.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let reactor = reactor else { return 0 }
        guard let sectionIndex = HomeListSectionIndex(rawValue: section) else { return 0 }
        
        switch sectionIndex {
        case .banner:
            return 1
        case .product:
            return reactor.currentState.listSection.products.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let reactor = reactor else { return .init() }
        guard let sectionIndex = HomeListSectionIndex(rawValue: indexPath.section) else { return .init() }
        
        switch sectionIndex {
        case .banner:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeListBannerCell.className) as! HomeListBannerCell
            cell.updateBanners(banners: reactor.currentState.listSection.banners)
            return cell
        case .product:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeListProductCell.className) as! HomeListProductCell
            guard let cellReactor = reactor.cellReactor[safe: indexPath.row] else { return cell }
            cell.reactor = cellReactor
            return cell
        }
    }
}
