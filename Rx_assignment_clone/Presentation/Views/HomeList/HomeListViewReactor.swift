//
//  HomeListViewReactor.swift
//  Rx_assignment_clone
//
//  Created by SeoDongyeon on 2021/11/09.
//

import ReactorKit
import RxSwift

final class HomeListViewReactor: Reactor {
    
    enum Action {
        case initialFetch
        case pullToRefresh
        case loadMore
        case likeProduct
    }
    
    enum Mutation {
        case setRefreshing(Bool)
        case appendItems([Product])
        case setListSection(ListSectionState)
    }
    
    struct State {
        var isRefreshing: Bool
        var listSection: ListSectionState
        
        var lastId: Int? {
            return listSection.products.last?.id
        }
        
        var bannerSectionCount: Int {
            return 1
        }
        
        var productSectionCount: Int {
            return listSection.products.count
        }
    }
    
    struct ListSectionState: Equatable {
        var banners: [Banner] = []
        var products: [Product] = []
    }
    
    var cellReactor: [HomeListProductCellReactor] {
        return currentState.listSection.products
            .map { .init(likedProductRepository: likedProductRepository, product: $0, shouldHideLikeButton: false)}
    }
    
    var initialState: State
    
    private let productRepository: ProductRepositoryType
    private let likedProductRepository: LikedProductRepositoryType

    init(productRepository: ProductRepositoryType, likedProductRepository: LikedProductRepositoryType) {
        self.productRepository = productRepository
        self.likedProductRepository = likedProductRepository
        
        self.initialState = State(isRefreshing: false, listSection: ListSectionState())
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .initialFetch:
            return fetchHomeListInfo()
            
        case .pullToRefresh:
            guard currentState.isRefreshing == false else { return .empty() }
            
            return Observable<Mutation>.concat(
                .just(.setRefreshing(true)),
                fetchHomeListInfo(),
                .just(.setRefreshing(false))
            )
            
        case .loadMore:
            guard let lastId = currentState.lastId else { return .empty() }
            return productRepository.getAdditionalProductList(lastId: lastId)
                .asObservable()
                .map { .appendItems($0)}
            
        default:
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setRefreshing(let isRefreshing):
            state.isRefreshing = isRefreshing
        case .appendItems(let items):
            state.listSection.products.append(contentsOf: items)
        case .setListSection(let listSection):
            state.listSection = listSection
        }
        return state
    }
    
    private func fetchHomeListInfo() -> Observable<Mutation> {
        return productRepository.getHomeListInfo()
            .asObservable()
            .map { response in
                var listSection = ListSectionState()
                
                listSection.banners = response.banners
                listSection.products = response.goods
                
                return .setListSection(listSection)
            }
    }
}
