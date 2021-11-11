//
//  LikedProductRepository.swift
//  Rx_assignment_clone
//
//  Created by SeoDongyeon on 2021/11/09.
//

import Foundation
import RxSwift
import RxCocoa

protocol LikedProductRepositoryType: AnyObject {
    var likedProducts: Observable<[Product]> { get }
    
    func likeProduct(product: Product)
}

final class LikedProductRepository: LikedProductRepositoryType {
    var likedProducts: Observable<[Product]> {
        likeProductRelay.asObservable()
    }
    
    func likeProduct(product: Product) {
        if let _ = likeProductRelay.value.first(where: { $0.id == product.id }) {
            let prevList = likeProductRelay.value
            let newList = prevList.filter { $0.id != product.id }
            likeProductRelay.accept(newList)
        } else {
            let prevList = likeProductRelay.value
            let newList = prevList + [product]
            likeProductRelay.accept(newList)
        }
    }
    
    private let likeProductRelay = BehaviorRelay<[Product]>(value: [])
    
    static let shared: LikedProductRepositoryType = LikedProductRepository()
    
    private init() {}
}
