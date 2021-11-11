//
//  HomeListInfo.swift
//  Rx_assignment_clone
//
//  Created by SeoDongyeon on 2021/11/09.
//

import Foundation

struct HomeListInfo {
    let banners: [Banner]
    let goods: [Product]
}

extension HomeListInfo {
    static var mockInfo: Self {
        return .init(banners: [
            Banner.mockData,
            Banner.mockData,
            Banner.mockData,
            Banner.mockData,
            Banner.mockData,
        ], goods: [
            Product.mockData,
            Product.mockData,
            Product.mockData,
            Product.mockData,
            Product.mockData,
            Product.mockData,
            Product.mockData,
            Product.mockData,
            Product.mockData,
            Product.mockData,
            Product.mockData,
            Product.mockData,
            Product.mockData,
            Product.mockData,
            Product.mockData,
        ])
    }
}
