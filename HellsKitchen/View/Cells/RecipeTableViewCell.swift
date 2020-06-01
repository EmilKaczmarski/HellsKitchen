//
//  recipeTableViewCell.swift
//  HellsKitchen
//
//  Created by Apple on 01/06/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit
import SnapKit

class RecipeTableViewCell: UITableViewCell {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    func setupView() {
        addSubview(stackView)
        stackView.snp.makeConstraints { (maker) in
            maker.centerX.centerY.leading.trailing.equalToSuperview()
        }
    }
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(leftView)
        stackView.addArrangedSubview(rightView)
        stackView.spacing = 4
        return stackView
    }()
    
    lazy var leftView: UIView = {
        let view = UIView()
        view.addSubview(imageBox)
        imageBox.snp.makeConstraints { (maker) in
            maker.centerX.centerY.equalToSuperview()
        }
        view.snp.makeConstraints { (maker) in
            maker.width.equalTo(88)
        }
        return view
    }()
    
    
    lazy var imageBox: UIImageView = {
        let imageBox = UIImageView()
        imageBox.snp.makeConstraints { (maker) in
            maker.width.equalTo(48)
            maker.height.equalTo(39)
        }
        imageBox.layer.cornerRadius = 10
        imageBox.layer.masksToBounds = true
        return imageBox
    }()
    
    lazy var rightView: UIView = {
        let view = UIView()
        view.addSubview(name)
        name.snp.makeConstraints { (maker) in
            maker.centerX.centerY.leading.trailing.bottom.top.equalToSuperview()
        }
        return view
    }()
    
    lazy var name: UILabel = {
        let name = UILabel()
        name.textColor = Constants.Colors.deepGreen
        name.font = UIFont.boldSystemFont(ofSize: 14.0)
        name.textAlignment = .left
        return name
    }()
}
