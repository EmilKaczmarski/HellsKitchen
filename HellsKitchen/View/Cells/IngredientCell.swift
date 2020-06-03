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
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.addArrangedSubview(leftView)
        stackView.addArrangedSubview(rightView)
        stackView.spacing = 4
        return stackView
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
        name.numberOfLines = 0
        name.lineBreakMode = .byWordWrapping
        name.font = UIFont.systemFont(ofSize: 14.0)
        name.textColor = Constants.Colors.deepGreen
        name.textAlignment = .left
        return name
    }()
    
    lazy var leftView: UIView = {
          let view = UIView()
          view.addSubview(weight)
          weight.snp.makeConstraints { (maker) in
              maker.centerX.centerY/*.leading.trailing.bottom.top*/.equalToSuperview()
          }
        view.snp.makeConstraints { (maker) in
            maker.width.equalTo(96)
        }
          return view
      }()
    
    lazy var weight: UILabel = {
        let weight = UILabel()
        weight.numberOfLines = 0
        weight.font = UIFont.systemFont(ofSize: 14.0)
        weight.textColor = Constants.Colors.deepGreen
        weight.textAlignment = .left
        return weight
    }()
    
}
