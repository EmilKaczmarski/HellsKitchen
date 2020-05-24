//
//  IngredientCell.swift
//  HellsKitchen
//
//  Created by Apple on 24/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit
import SnapKit

class IngredientCell: UITableViewCell {
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
            maker.centerX.centerY.trailing.top.bottom.equalToSuperview()
        }
    }
    
    lazy var name: UILabel = {
        let name = UILabel()
        name.numberOfLines = 0
        return name
    }()
    
    lazy var weight: UILabel = {
        let weight = UILabel()
        weight.numberOfLines = 0
        return weight
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.addArrangedSubview(name)
        stackView.addArrangedSubview(weight)
        return stackView
    }()
    
}
