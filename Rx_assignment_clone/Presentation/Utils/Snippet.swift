//
//  Snippet.swift
//  Rx_assignment_clone
//
//  Created by SeoDongyeon on 2021/11/09.
//

import UIKit
import RxSwift

// http://stackoverflow.com/a/30593673/1556838
extension Collection where Indices.Iterator.Element == Index {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Reactive where Base: UIScrollView {
    var loadMore: Observable<Void> {
        return base.rx.contentOffset
            .map { [weak base] _ in base?.needsMoreData() }
            .filterNil()
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in Void() }
    }
}


extension UIScrollView {
    func needsMoreData() -> Bool {
        let inset = adjustedContentInset

        // 컨텐츠가 테이블 뷰 크기보다 적음
        if contentOffset.y == -inset.top && contentSize.height < frame.inset(by: inset).height {
            return true
        }

        // 컨텐츠 끝이 테이블 뷰 마지막을 지남
        if contentSize.height - contentOffset.y < frame.height - inset.bottom {
            return true
        }
        // 위 두 케이스가 아니면 로딩할 필요 없음
        return false
    }
    
    var adjustedContentOffset: CGPoint {
        var offset = contentOffset
        offset.x += adjustedContentInset.left
        offset.y += adjustedContentInset.top
        return offset
    }
}
