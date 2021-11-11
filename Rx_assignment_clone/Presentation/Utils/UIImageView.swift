//
//  UIImageView.swift
//  Rx_assignment_clone
//
//  Created by SeoDongyeon on 2021/11/09.
//

import SDWebImage

extension UIImageView {
    func setDownloadableImage(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        self.sd_setImage(with: url)
    }
}
