//
//  MessageCell.swift
//  HellsKitchen
//
//  Created by Apple on 13/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit
import SnapKit

class MessageCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
           addSubview(view)
           view.snp.makeConstraints { (maker) in
               maker.centerX.centerY.trailing.leading.top.bottom.equalToSuperview()
           }
    }

    lazy var data: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var view: UIView = {
        let view = UIView()
        view.addSubview(data)
        view.layer.cornerRadius = 20.0
        data.snp.makeConstraints { (maker) in
            maker.centerX.trailing.equalToSuperview()
        }
        return view
    }()
    
}
