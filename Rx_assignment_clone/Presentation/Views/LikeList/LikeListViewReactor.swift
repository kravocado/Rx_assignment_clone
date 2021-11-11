//
//  LikeListViewReactor.swift
//  Rx_assignment_clone
//
//  Created by SeoDongyeon on 2021/11/10.
//

import ReactorKit
import RxSwift

final class LikeListViewReactor: Reactor {
    enum Mutation {
        case setItems([Product])
    }
    
    struct State {
        var products: [Product]
    }
    
    var cellReactors: [HomeListProductCellReactor] {
        return currentState.products
            .map { .init(likedProductRepository: likedProductRepository, product: $0, shouldHideLikeButton: true)}
    }
    
    var initialState: State
    
    private let likedProductRepository: LikedProductRepositoryType
    
    init(likedProductRepository: LikedProductRepositoryType) {
        self.likedProductRepository = likedProductRepository
        
        self.initialState = State(products: [])
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setItems(let items):
            state.products = items
        }
        return state
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        return Observable.merge(
            mutation,
            likedProductRepository.likedProducts
                .distinctUntilChanged()
                .map { Mutation.setItems($0)}
        )
    }
}
