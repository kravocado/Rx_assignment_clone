//
//  CellRegisterEx.swift
//  Rx_assignment_clone
//
//  Created by SeoDongyeon on 2021/11/09.
//

import UIKit
import RxSwift

protocol ClassNameStringConvertible {
    static var className: String { get }
    var className: String { get }
}

extension ClassNameStringConvertible {
    static var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return String(describing: type(of: self))
    }
}

extension NSObject: ClassNameStringConvertible { }

extension UITableView {
    func register<T>(cellClass: T.Type) where T: UITableViewCell {
        register(T.self, forCellReuseIdentifier: T.className)
    }
}

extension UICollectionView {
    func register<T>(cellClass: T.Type) where T: UICollectionViewCell {
        register(T.self, forCellWithReuseIdentifier: T.className)
    }
}
