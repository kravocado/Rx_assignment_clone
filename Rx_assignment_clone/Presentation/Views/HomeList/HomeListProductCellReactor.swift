//
//  HomeListProductCellReactor.swift
//  Rx_assignment_clone
//
//  Created by SeoDongyeon on 2021/11/10.
//

import ReactorKit
import RxSwift

final class HomeListProductCellReactor: Reactor {
    enum Action {
        case like
    }
    
    enum Mutation {
        case setLike(Bool)
    }
    
    struct State {
        var product: Product
        var isLiked: Bool
        var shouldHideLikeButton: Bool
    }
    
    var initialState: State
    
    private let likedProductRepository: LikedProductRepositoryType
    
    init(likedProductRepository: LikedProductRepositoryType, product: Product, shouldHideLikeButton: Bool) {
        self.likedProductRepository = likedProductRepository
        self.initialState = State(product: product, isLiked: false, shouldHideLikeButton: shouldHideLikeButton)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .like:
            _ = likedProductRepository.likeProduct(product: currentState.product)
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setLike(let isLiked):
            state.isLiked = isLiked
        }
        return state
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        return Observable.merge(
            mutation,
            likedProductRepository.likedProducts
                .distinctUntilChanged()
                .map { [weak self] likedProducts in
                    guard let ss = self else { return false }
                    let currentProductId = ss.currentState.product.id
                    return likedProducts.contains(where: { $0.id == currentProductId })
                }
                .map { Mutation.setLike($0) }
        )
    }
}
