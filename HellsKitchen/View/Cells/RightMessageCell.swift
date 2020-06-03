//
//  MessageCell.swift
//  HellsKitchen
//
//  Created by Apple on 13/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit
import SnapKit

class RightMessageCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        addSubview(finalStackView)
        finalStackView.snp.makeConstraints { (maker) in
            maker
                .centerX
                .bottom
                .leading
                .top
                .trailing
                .equalToSuperview()
        }
        backgroundColor = .clear
    }
    //MARK: - final stack view
    lazy var finalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.addArrangedSubview(wholeMessageView)
        stack.addArrangedSubview(imageComponent)
        
        stack.backgroundColor = .clear
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
        return imageBox
    }()
    
    //MARK: - whole message
    lazy var wholeMessageView: UIView = {
        let view = UIView()
        view.addSubview(messageStackView)
        messageStackView.snp.makeConstraints { (maker) in
            maker.centerX.leading.top.bottom.trailing.equalToSuperview()
            maker.height.greaterThanOrEqualTo(73)
        }
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var messageStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.addArrangedSubview(bodyViewWrapper)
        stack.addArrangedSubview(bodyViewReminder)
        stack.addArrangedSubview(reminderPhotoSeparator)
        bodyView.snp.makeConstraints { (maker) in
            maker.top.trailing.equalToSuperview().offset(12)
            maker.bottom.right.equalToSuperview().offset(-12)
        }
        stack.backgroundColor = .clear
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
        view.addSubview(bodyViewReminderBottom)
        bodyViewReminderBottom.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.bottom.equalToSuperview().offset(-12)
            
        }
        view.snp.makeConstraints { (maker) in
            maker.width.equalTo(6)
        }
        return view
    }()
    
    lazy var bodyViewReminderBottom: UIView = {
        let view = UIView()
        let triLabelView = TriLabelView(frame: CGRect(x: 0, y: -6, width: 12, height: 12))
        view.addSubview(triLabelView)
        triLabelView.viewColor = Constants.Colors.deepGreen
        triLabelView.position = .BottomLeft
        view.snp.makeConstraints { (maker) in
            maker.height.equalTo(6)
            maker.width.equalTo(6)
        }
        return view
    }()
    
    //MARK: - left stack sub view top
    lazy var bodyViewWrapper: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.addArrangedSubview(bodyView)
        stack.addArrangedSubview(footerView)
        return stack
    }()
    
    lazy var bodyView: UIView = {
        let view = UIView()
        view.addSubview(bodyStackView)
        bodyStackView.snp.makeConstraints { (maker) in
            maker.bottom.equalToSuperview()
            maker.left.top.equalToSuperview().offset(12)
            maker.right.equalToSuperview().offset(-12)
        }
        view.backgroundColor = Constants.Colors.deepGreen
        
        view.layer.cornerRadius = 5
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner]
        return view
    }()
    
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
        message.snp.makeConstraints { (maker) in
            maker.centerX.leading.trailing.equalToSuperview()
        }
        date.snp.makeConstraints { (maker) in
            maker.centerX.leading.trailing.equalToSuperview()
        }
        return stack
    }()
    
    lazy var message: UILabel = {
        let message = UILabel()
        message.textAlignment = .left
        message.lineBreakMode = .byWordWrapping
        message.numberOfLines = 0
        message.font = UIFont(name: "Poppins-Regular", size: 14)
        message.textColor = Constants.Colors.ice
        return message
    }()
    
    lazy var date: UILabel = {
        let date = UILabel()
        date.textAlignment = .left
        date.lineBreakMode = .byWordWrapping
        date.numberOfLines = 0
        date.font = UIFont(name: "Poppins-Regular", size: 12)
        date.textColor = Constants.Colors.lightGray
        return date
    }()
    
    //MARK: - left stack sub view top
    lazy var leftBottomView: UIView = {
        let view = UIView()
        view.snp.makeConstraints { (maker) in
            maker.height.equalTo(12)
        }
        view.backgroundColor = Constants.Colors.deepGreen
        return view
    }()
    //MARK: - footer
    lazy var footerView: UIView = {
        let view = UIView()
        view.snp.makeConstraints { (maker) in
            maker.height.equalTo(11)
        }
        view.backgroundColor = .white
        return view
    }()
}
