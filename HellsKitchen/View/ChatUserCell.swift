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
    
    func createAvatar(for username: String)-> UIImage {
        let configuration = LetterAvatarBuilderConfiguration()
        configuration.size = CGSize(width: Constants.Sizes.avatarSize, height: Constants.Sizes.avatarSize)
        configuration.username = username
        configuration.circle = true
        configuration.backgroundColors = [ .red ]
        return UIImage.makeLetterAvatar(withConfiguration: configuration)!
    }
    
    lazy var avatarImageView: UIImageView = {
        let view = UIImageView()
        view.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(Constants.Sizes.avatarSize + 5)
        }
        return view
    }()
    
    lazy var avatar: UIView = {
       let view = UIView()
        view.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { (maker) in
            maker.trailing.centerY.equalToSuperview()
        }
        
        view.snp.makeConstraints { (maker) in
            maker.width.equalTo(Constants.Sizes.avatarSize + 50)
        }
        return view
    }()
    
    lazy var name: UILabel = {
        let name = UILabel()
        name.textAlignment = .center
        return name
    }()
    
    lazy var stack: UIStackView = {
       let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.addArrangedSubview(avatar)
        stack.addArrangedSubview(name)
        return stack
    }()
    
    lazy var view: UIView = {
        let view = UIView()
        addSubview(stack)
        stack.snp.makeConstraints { (maker) in
            maker.centerX.centerY.top.leading.trailing.bottom.equalToSuperview()
        }
        return view
    }()
    
    func setupView() {
        addSubview(view)
        view.snp.makeConstraints { (maker) in
            maker.centerX.centerY.trailing.leading.top.bottom.equalToSuperview()
        }
    }
}

