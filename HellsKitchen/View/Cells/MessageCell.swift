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
    static var isUsersMessage: Bool?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
//    if MessageCell.isUsersMessage! {
//        view.backgroundColor = Constants.Colors.deepGreen
//    } else {
//        view.backgroundColor = .white
//    }
    func setupView() {
        //addSubview(finalStackView)
        addSubview(finalStackView)
        backgroundColor = Constants.Colors.deepGreen
        finalStackView.snp.makeConstraints { (maker) in
            maker.centerX.bottom.leading.top.trailing.equalToSuperview()
        }
        
    }
    //MARK: - final stack view
    lazy var finalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        if MessageCell.isUsersMessage! {
            stack.addArrangedSubview(wholeMessageView)
            stack.addArrangedSubview(imageComponent)
        } else {
            stack.addArrangedSubview(imageComponent)
            stack.addArrangedSubview(wholeMessageView)
        }
        return stack
    }()
    
    //MARK: - photo
    lazy var imageComponent: UIView = {
        let view = UIView()
        view.addSubview(imageBox)
        imageBox.snp.makeConstraints { (maker) in
            maker.leading.trailing.bottom.equalToSuperview()
        }
        return view
    }()
    
    lazy var imageBox: UIImageView = {
        let imageBox = UIImageView()
        imageBox.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(40)
        }
        imageBox.layer.cornerRadius = 20
        imageBox.layer.masksToBounds = true
        imageBox.layer.borderColor = UIColor.white.cgColor
        return imageBox
    }()
    
    //MARK: - whole message
    lazy var wholeMessageView: UIView = {
        let view = UIView()
        view.addSubview(messageStackView)
        
        messageStackView.snp.makeConstraints { (maker) in
//            maker.leading.trailing.top.equalToSuperview()
//            maker.bottom.equalToSuperview().offset(-11)
            maker.centerX.leading.top.bottom.trailing.equalToSuperview()
            maker.height.greaterThanOrEqualTo(40)
           // maker.bottom.equalToSuperview().offset(11)
        }
        return view
    }()
    
    lazy var messageStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        if MessageCell.isUsersMessage! {
            stack.addArrangedSubview(bodyStackView)
            stack.addArrangedSubview(bodyViewReminder)
            stack.addArrangedSubview(reminderPhotoSeparator)
        } else {
            stack.addArrangedSubview(reminderPhotoSeparator)
            stack.addArrangedSubview(bodyViewReminder)
            stack.addArrangedSubview(bodyStackView)
        }
        return stack
    }()
    
    //MARK: - reminder - photo separator
    lazy var reminderPhotoSeparator: UIView = {
        let view = UIView()
        view.snp.makeConstraints { (maker) in
            maker.width.equalTo(8)
        }
        return view
    }()
    
    //MARK: - left view reminder
    lazy var bodyViewReminder: UIView = {
        let view = UIView()
        view.snp.makeConstraints { (maker) in
            maker.width.equalTo(6)
        }
        return view
    }()
    
    
    //MARK: - left stack sub view top
    
    lazy var bodyStackView: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(bodySubStackView)
        stack.addArrangedSubview(leftBottomView)
        stack.axis = .vertical
        stack.spacing = 0
        return stack
    }()
    
    lazy var bodySubStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.addArrangedSubview(message)
        stack.addArrangedSubview(date)
        return stack
    }()
    
    lazy var message: UILabel = {
        let message = UILabel()
        message.textAlignment = .left
        message.lineBreakMode = .byWordWrapping
        message.numberOfLines = 0
        message.font = UIFont(name: "Poppins-Regular", size: 14)
        if MessageCell.isUsersMessage! {
            message.textColor = Constants.Colors.ice
        } else {
            message.textColor = Constants.Colors.deepGreen
        }
        return message
    }()
    
    lazy var date: UILabel = {
        let date = UILabel()
        date.textAlignment = .left
        date.lineBreakMode = .byWordWrapping
        date.numberOfLines = 0
        date.font = UIFont(name: "Poppins-Regular", size: 14)
        date.textColor = Constants.Colors.lightGray
        return message
    }()
    
    //MARK: - left stack sub view top
    lazy var leftBottomView: UIView = {
        let view = UIView()
        view.snp.makeConstraints { (maker) in
            maker.height.equalTo(12)
        }
        return view
    }()
    
}
