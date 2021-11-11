//
//  UIViewEx.swift
//  Rx_assignment_clone
//
//  Created by SeoDongyeon on 2021/11/09.
//

import UIKit

class ContentSizeView: UIView {
    override var intrinsicContentSize: CGSize {
        return contentSize ?? CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
    }
    
    var contentSize: CGSize? {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    init(frame: CGRect, contentSize: CGSize?) {
        super.init(frame: frame)
        self.contentSize = contentSize
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {
    static func stackViewPadding(width: CGFloat? = nil,
                                 height: CGFloat? = nil,
                                 compressionResistancePriority: UILayoutPriority = .required,
                                 huggingPriority: UILayoutPriority = .defaultHigh) -> ContentSizeView {
        let padding = ContentSizeView(frame: .zero, contentSize: CGSize(width: width ?? 0, height: height ?? 0))
        padding.backgroundColor = .clear
        padding.isUserInteractionEnabled = false
        if width != nil {
            padding.setContentHuggingPriority(huggingPriority, for: .horizontal)
            padding.setContentCompressionResistancePriority(compressionResistancePriority, for: .horizontal)
        }
        if height != nil {
            padding.setContentHuggingPriority(huggingPriority, for: .vertical)
            padding.setContentCompressionResistancePriority(compressionResistancePriority, for: .vertical)
        }
        return padding
    }
    
    func applyRound(_ radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
}
