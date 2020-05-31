//
//  RecipeCategoryCell.swift
//  HellsKitchen
//
//  Created by Apple on 31/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit
import SnapKit

class RecipeCategoryCell: UITableViewCell {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    func setupView() {
        addSubview(view)
        view.snp.makeConstraints { (maker) in
            maker.centerX.centerY.top.bottom.equalToSuperview()
            maker.leading.equalToSuperview().offset(20)
            maker.trailing.equalToSuperview().offset(20)
        }
    }
    
    lazy var view: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.deepGreen
        view.addSubview(labelView)
        labelView.snp.makeConstraints { (maker) in
            maker.centerX.centerY.top.trailing.bottom.equalToSuperview()
        }
        return view
    }()

    
    lazy var labelView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addSubview(name)
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner] 
        
        name.snp.makeConstraints { (maker) in
            maker.centerX.trailing.leading.centerY.equalToSuperview()
        }
        return view
    }()
    
    lazy var name: UILabel = {
       let textLabel = UILabel()
        textLabel.textAlignment = .left
        textLabel.textColor = Constants.Colors.deepGreen
        return textLabel
    }()
    
}
