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
        addSubview(stackView)
        stackView.snp.makeConstraints { (maker) in
            maker.centerX.centerY.trailing.equalToSuperview()
        }
    }
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.addArrangedSubview(leftView)
        stackView.addArrangedSubview(view)
        stackView.addArrangedSubview(rightView)
        return stackView
    }()
    
    lazy var leftView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var rightView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var data: UILabel = {
        let data = UILabel()
        data.textAlignment = .center
        data.numberOfLines = 0
        data.lineBreakMode = .byWordWrapping
        return data
    }()
    
    lazy var view: UIView = {
       let view = UIView()
        view.addSubview(data)
        view.layer.cornerRadius = 3.0
        data.snp.makeConstraints { (maker) in
            maker.bottom.top.leading.trailing.equalToSuperview()
        }
        return view
    }()
    
}
