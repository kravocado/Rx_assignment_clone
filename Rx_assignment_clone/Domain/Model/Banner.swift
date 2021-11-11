//
//  Banner.swift
//  Rx_assignment_clone
//
//  Created by SeoDongyeon on 2021/11/09.
//

import Foundation

struct Banner: Equatable {
    let id: Int
    let image: String
}

extension Banner {
    static var mockData: Banner {
        let ramdomId = Int.random(in: 0...10000)
        return Banner.init(id: ramdomId, image: "https://picsum.photos/200/300?random=\(ramdomId)")
    }
}



