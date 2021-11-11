//
//  LikeListViewController.swift
//  Rx_assignment_clone
//
//  Created by SeoDongyeon on 2021/11/09.
//

import UIKit
import ReactorKit
import RxSwift
import RxAppState
import SnapKit

class LikeListViewController: UIViewController, View {

    typealias Reactor = LikeListViewReactor
    
    private let tableView = UITableView()
    
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
        navigationController?.navigationBar.topItem?.title = "좋아요"
        
        view.addSubview(tableView)
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.register(cellClass: HomeListProductCell.self)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bind(reactor: Reactor) {
        reactor.state.map { $0.products }
        .distinctUntilChanged()
        .subscribe(onNext: { [weak tableView] product in
            tableView?.reloadData()
        })
        .disposed(by: disposeBag)
    }
    
}

extension LikeListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let reactor = reactor else { return 0 }
        return reactor.currentState.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let reactor = reactor else { return .init() }
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeListProductCell.className) as! HomeListProductCell
        guard let cellReactor = reactor.cellReactors[safe: indexPath.row] else { return cell }
        cell.reactor = cellReactor
        return cell
    }
}
