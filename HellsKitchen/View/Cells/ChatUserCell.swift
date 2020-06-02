//
//  ChatUserCell.swift
//  HellsKitchen
//
//  Created by Apple on 18/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit
import SnapKit
import LetterAvatarKit

class ChatUserCell: UITableViewCell {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    private func setupView() {
        addSubview(stackView)
        stackView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(16)
            maker.bottom.equalToSuperview().offset(-14)
            maker.trailing.equalToSuperview().offset(-20)
            maker.leading.equalToSuperview().offset(20)
        }
    }
    
    //MARK: - stackView
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 24
        stackView.addArrangedSubview(leftView)
        stackView.addArrangedSubview(middleStackView)
        stackView.addArrangedSubview(rightView)
        return stackView
    }()
    
    //MARK: - image
    lazy var imageBox: UIImageView = {
        let imageBox = UIImageView()
        imageBox.layer.masksToBounds = true
        imageBox.layer.borderColor = UIColor.white.cgColor
        imageBox.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(40)
        }
        imageBox.layer.cornerRadius = 20
        return imageBox
    }()
    
    lazy var leftView: UIView = {
        let view = UIView()
        view.addSubview(imageBox)
        view.snp.makeConstraints { (maker) in
            maker.width.equalTo(40)
        }
        imageBox.snp.makeConstraints { (maker) in
            maker.centerX.centerY.equalToSuperview()
        }
        return view
    }()
    
    //MARK: - middle label
    
    lazy var name: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Colors.deepGreen
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        label.snp.makeConstraints { (maker) in
            maker.height.equalTo(20)
        }
        return label
    }()
    
    lazy var lastMessage: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12)
        label.snp.makeConstraints { (maker) in
            maker.height.equalTo(17)
        }
        return label
    }()
    
    lazy var middleStackView: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(name)
        stack.addArrangedSubview(lastMessage)
        stack.spacing = 4
        stack.axis = .vertical
        stack.snp.makeConstraints { (maker) in
            maker.width.equalTo(136)
            maker.height.equalTo(41)
        }
        return stack
    }()
    
    lazy var middleView: UIView = {
        let view = UIView()
        view.addSubview(middleStackView)
        middleStackView.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
        }
        return view
    }()
    //MARK: - rightView
    
    lazy var date: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 12)
        label.snp.makeConstraints { (maker) in
            maker.height.equalTo(17)
        }
        return label
    }()
    
    lazy var rightView: UIView = {
        let view = UIView()
        view.addSubview(date)
        date.snp.makeConstraints { (maker) in
            maker.centerX.trailing.leading.equalToSuperview()
            maker.bottom.equalToSuperview().offset(-5)
        }
        return view
    }()
}

