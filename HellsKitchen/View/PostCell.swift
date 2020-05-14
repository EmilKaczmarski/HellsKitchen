//
//  PostCell.swift
//  HellsKitchen
//
//  Created by Apple on 14/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit
import SnapKit

class PostCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(postView)
        postView.snp.makeConstraints { (maker) in
            maker.centerX.trailing.bottom.equalToSuperview()
            maker.top.equalToSuperview().offset(20.0)
        }
        backgroundColor = .clear
    }
    
    lazy var owner: UILabel = {
       let owner = UILabel()
        owner.textAlignment = .left
        owner.numberOfLines = 0
        owner.lineBreakMode = .byWordWrapping
        return owner
    }()
    
    lazy var title: UILabel = {
        let title = UILabel()
        title.textAlignment = .center
        title.numberOfLines = 0
        title.lineBreakMode = .byWordWrapping
        return title
    }()
    
    lazy var content: UILabel = {
        let content = UILabel()
        content.textAlignment = .center
        content.numberOfLines = 0
        content.lineBreakMode = .byWordWrapping
        return content
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(owner)
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(content)
        stackView.axis = .vertical
        return stackView
    }()
    
    lazy var postView: UIView = {
        let view = UIView()
        view.addSubview(stackView)
        stackView.snp.makeConstraints { (maker) in
            maker.centerX.trailing.top.bottom.equalToSuperview()
        }
        view.layer.cornerRadius = 10.0
        view.backgroundColor = .lightGray
        return view
    }()
}
