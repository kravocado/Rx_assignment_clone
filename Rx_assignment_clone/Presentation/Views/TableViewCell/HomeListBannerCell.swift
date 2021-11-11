//
//  HomeListBannerCell.swift
//  Rx_assignment_clone
//
//  Created by SeoDongyeon on 2021/11/09.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import SnapKit

final class HomeListBannerCell: UITableViewCell {
    typealias Cell = BannerCollectionViewCell
    
    struct PageInfo: Equatable {
        var current: Int
        var total: Int
    }
    
    private let pageLabel = UIButton()
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 263)
        flowLayout.minimumLineSpacing = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(cellClass: Cell.self)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    private var disposeBag = DisposeBag()
    
    fileprivate var items: [Banner] = [] {
        didSet {
            collectionView.reloadData()
            updateTotalPage(total: items.count)
        }
    }
    
    private let pageRelay = BehaviorRelay<PageInfo>(value: .init(current: 0, total: 0))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUp()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        contentView.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(263)
        }
        
        contentView.addSubview(pageLabel)
        pageLabel.isUserInteractionEnabled = false
        pageLabel.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        pageLabel.setTitleColor(Palette.white, for: .normal)
        pageLabel.backgroundColor = Palette.black20
        pageLabel.applyRound(12.5)
        pageLabel.contentEdgeInsets = .init(top: 4, left: 11, bottom: 4, right: 11)
        pageLabel.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().inset(16)
            make.width.equalTo(48)
        }
    }
    
    private func bind() {
        collectionView.rx.swipeGesture(.left)
            .subscribe(onNext: { [weak self] _ in
                guard let ss = self else { return }
                ss.scrollToNext()
            })
            .disposed(by: disposeBag)
        
        collectionView.rx.swipeGesture(.right)
            .subscribe(onNext: { [weak self] _ in
                guard let ss = self else { return }
                ss.scrollToPrev()
            })
            .disposed(by: disposeBag)
        
        pageRelay
            .distinctUntilChanged()
            .map { "\($0.current + 1)/\($0.total)"}
            .bind(to: pageLabel.rx.title())
            .disposed(by: disposeBag)
    }
    
    private func scrollToNext() {
        guard let currentIndexPath = collectionView.indexPathsForVisibleItems.first else { return }
        let nextIndexPath = IndexPath(row: currentIndexPath.row + 1, section: 0)
        guard nextIndexPath.row < items.count else { return }
        collectionView.scrollToItem(at: nextIndexPath, at: .left, animated: true)
        
        updateCurrentPage(current: nextIndexPath.row)
    }
    
    private func scrollToPrev() {
        guard let currentIndexPath = collectionView.indexPathsForVisibleItems.first else { return }
        let prevIndexPath = IndexPath(row: currentIndexPath.row - 1, section: 0)
        guard prevIndexPath.row >= 0 else { return }
        collectionView.scrollToItem(at: prevIndexPath, at: .left, animated: true)
        
        updateCurrentPage(current: prevIndexPath.row)
    }
    
    private func updateCurrentPage(current: Int) {
        let totalPage = pageRelay.value.total
        pageRelay.accept(.init(current: current, total: totalPage))
    }
    
    private func updateTotalPage(total: Int) {
        let currentPage = pageRelay.value.current
        pageRelay.accept(.init(current: currentPage, total: total))
    }
    
    func updateBanners(banners: [Banner]) {
        items = banners
    }
}

extension HomeListBannerCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.className, for: indexPath) as! Cell
        guard let item = items[safe: indexPath.row] else { return cell }
        cell.configure(with: item.image)
        return cell
    }
}
