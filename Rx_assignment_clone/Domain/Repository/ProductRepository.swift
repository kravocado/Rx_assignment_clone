//
//  ProductRepository.swift
//  Rx_assignment_clone
//
//  Created by SeoDongyeon on 2021/11/09.
//

import Foundation
import RxSwift

protocol ProductRepositoryType: AnyObject {
    func getHomeListInfo() -> Single<HomeListInfo>
    func getAdditionalProductList(lastId: Int) -> Single<[Product]>
}

final class MockProductRepository: ProductRepositoryType {
    
    func getHomeListInfo() -> Single<HomeListInfo> {
        return Single.just(HomeListInfo.mockInfo)
    }
    
    func getAdditionalProductList(lastId: Int) -> Single<[Product]> {
        return Single.just([Product.mockData])
    }
}
