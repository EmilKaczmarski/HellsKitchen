//
//  Extensions.swift
//  HellsKitchen
//
//  Created by Apple on 19/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit
import SnapKit
//MARK: - String
extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        let end = index(start, offsetBy: min(self.count - range.lowerBound,
                                             range.upperBound - range.lowerBound))
        return String(self[start..<end])
    }

    subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
         return String(self[start...])
    }
}

//MARK: -UIColor

extension UIColor {
    convenience init(hexaString: String, alpha: CGFloat = 1) {
        let chars = Array(hexaString.dropFirst())
        self.init(red:   .init(strtoul(String(chars[0...1]),nil,16))/255,
                  green: .init(strtoul(String(chars[2...3]),nil,16))/255,
                  blue:  .init(strtoul(String(chars[4...5]),nil,16))/255,
            alpha: alpha)}
}

//MARK: -UIViewController
extension UIViewController {
    func setTitle(_ title: String, andImage image: UIImage) {
        let titleLbl = UILabel()
        titleLbl.text = title
        titleLbl.textColor = Constants.Colors.deepGreen
        titleLbl.font = UIFont(name: "PlayfairDisplay-Bold", size: 14.0)
        let imageView = UIImageView(image: image)
        imageView.snp.makeConstraints { (maker) in
            maker.width.equalTo(15.0)
            maker.height.equalTo(23.0)
        }
        let titleView = UIStackView(arrangedSubviews: [titleLbl, imageView])
        titleView.axis = .horizontal
        titleView.spacing = 10.0
        navigationItem.titleView = titleView
    }
}

//MARK: -UIImage


