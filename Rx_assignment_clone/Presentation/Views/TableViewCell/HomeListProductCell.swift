//
//  HomeListProductCell.swift
//  Rx_assignment_clone
//
//  Created by SeoDongyeon on 2021/11/09.
//

import UIKit
import SnapKit
import ReactorKit
import RxSwift

final class HomeListProductCell: UITableViewCell, View {
    typealias Reactor = HomeListProductCellReactor
    
    private let productImageView = UIImageView()
    private let likeButton = UIButton()
    private let productInfoContainerStackView = UIStackView()
    private let discountRateLabel = UILabel()
    private let priceLabel = UILabel()
    private let nameLabel = UILabel()
    private let isNewBadgeImageView = UIImageView()
    private let sellCountLabel = UILabel()
    
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        contentView.addSubview(productImageView)
        productImageView.applyRound(4)
        productImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
            make.size.equalTo(80)
        }
        
        contentView.addSubview(likeButton)
        likeButton.setBackgroundImage(UIImage(named: "iconCardZzim"), for: .normal)
        likeButton.setBackgroundImage(UIImage(named: "iconCardZzimSelected"), for: .selected)
        likeButton.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.top.trailing.equalTo(productImageView).inset(8)
        }
        
        contentView.addSubview(productInfoContainerStackView)
        productInfoContainerStackView.axis = .vertical
        productInfoContainerStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.leading.equalTo(productImageView.snp.trailing).offset(12)
            make.bottom.equalToSuperview().inset(25)
            make.trailing.equalToSuperview().inset(22)
        }
        
        do {
            let containerView = UIView()
            productInfoContainerStackView.addArrangedSubview(containerView)
            
            let stackView = UIStackView()
            containerView.addSubview(stackView)
            stackView.axis = .horizontal
            stackView.spacing = 5
            stackView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
            }
            
            stackView.addArrangedSubview(discountRateLabel)
            discountRateLabel.textColor = Palette.watermelon
            discountRateLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            discountRateLabel.setContentHuggingPriority(.required, for: .horizontal)
            
            stackView.addArrangedSubview(priceLabel)
            priceLabel.textColor = Palette.black
            priceLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        }
        
        do {
            productInfoContainerStackView.addArrangedSubview(.stackViewPadding(height: 5))
            productInfoContainerStackView.addArrangedSubview(nameLabel)
            productInfoContainerStackView.addArrangedSubview(.stackViewPadding(height: 17))
            
            nameLabel.textColor = Palette.brownishGray
            nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            nameLabel.numberOfLines = 0
        }
        
        do {
            let containerView = UIView()
            productInfoContainerStackView.addArrangedSubview(containerView)
            
            let horizontalStackView = UIStackView()
            containerView.addSubview(horizontalStackView)
            horizontalStackView.axis = .horizontal
            horizontalStackView.spacing = 4
            horizontalStackView.snp.makeConstraints { make in
                make.leading.top.bottom.equalToSuperview()
            }
            
            horizontalStackView.addArrangedSubview(isNewBadgeImageView)
            isNewBadgeImageView.image = UIImage(named: "imgBadgeNew")
            
            horizontalStackView.addArrangedSubview(sellCountLabel)
            sellCountLabel.textColor = Palette.brownishGray
            sellCountLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        }
        
        let divider = UIView()
        contentView.addSubview(divider)
        divider.backgroundColor = Palette.veryLightPink
        divider.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func configure(product: Product, showHideLikeButton: Bool) {
        productImageView.setDownloadableImage(urlString: product.image)
        likeButton.isHidden = showHideLikeButton
        discountRateLabel.isHidden = product.discountRate <= 0
        discountRateLabel.text = "\(product.discountRate)%"
        priceLabel.text = "\(product.actualPrice)"
        nameLabel.text = product.name
        isNewBadgeImageView.isHidden = !product.isNew
        sellCountLabel.isHidden = !product.isSellCountVisible
        sellCountLabel.text = "\(product.sellCount)개 구매중"
    }
    
    func bind(reactor: Reactor) {
        configure(product: reactor.currentState.product, showHideLikeButton: reactor.currentState.shouldHideLikeButton)
        
        likeButton.rx.tap
            .map { Reactor.Action.like }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLiked }
            .distinctUntilChanged()
            .bind(to: likeButton.rx.isSelected)
            .disposed(by: disposeBag)
    }
}
