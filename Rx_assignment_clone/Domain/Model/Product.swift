//
//  Product.swift
//  Rx_assignment_clone
//
//  Created by SeoDongyeon on 2021/11/09.
//

import Foundation

struct Product: Equatable {
    let id: Int
    let name: String
    let image: String
    let actualPrice: Int
    let price: Int
    let isNew: Bool
    let sellCount: Int
    
    var isLiked: Bool
}

extension Product {
    var discountRate: Int {
        guard actualPrice > 0 else { return 0 }
        let discountRate: Double = 1 - (Double(price) / Double(actualPrice))
        return Int(discountRate * 100)
    }
    
    var isSellCountVisible: Bool {
        return sellCount >= 10
    }
}

extension Product {
    static var mockData: Product {
        let ramdomId = Int.random(in: 0...10000)
        return Product.init(
            id: ramdomId,
            name: "Hello",
            image: "https://picsum.photos/200/300?random=\(ramdomId)",
            actualPrice: 3333,
            price: 4444,
            isNew: true,
            sellCount: 5555,
            isLiked: false)
    }
}
