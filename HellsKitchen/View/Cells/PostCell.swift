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
        backgroundColor = UIColor.white
    }
    
    lazy var postImage: UIImageView = {
       let image = UIImageView()
        image.snp.makeConstraints { (maker)
            in
            maker.width.equalTo(335)
            maker.height.equalTo(200)
        }
        image.layer.cornerRadius = 3
        image.layer.masksToBounds = true
        return image
    }()
    
    lazy var profileImage: UIImageView = {
        let profile = UIImageView()
        profile.snp.makeConstraints { (maker)
            in
            maker.width.equalTo(30)
            maker.height.equalTo(30)
        }
        profile.layer.cornerRadius = profile.bounds.width / 2
        profile.layer.masksToBounds = true
        return profile
    }()

    lazy var date: UILabel = {
        let date = UILabel()
        date.textAlignment = .left
        date.numberOfLines = 0
        date.lineBreakMode = .byWordWrapping
        date.font = UIFont.systemFont(ofSize: 12.0)
        date.textColor = UIColor.lightGray
        return date
    }()
    
    lazy var owner: UILabel = {
        let owner = UILabel()
        owner.textAlignment = .left
        owner.numberOfLines = 1
        owner.font = UIFont.systemFont(ofSize: 14.0)
        owner.textColor = Constants.Colors.deepGreen
        return owner
    }()

    lazy var title: UILabel = {
        let title = UILabel()
        title.textAlignment = .left
        title.numberOfLines = 0
        title.lineBreakMode = .byWordWrapping
        title.font = UIFont.boldSystemFont(ofSize: 16.0)
        title.textColor = Constants.Colors.deepGreen
        return title
    }()
    
    lazy var content: UILabel = {
        let content = UILabel()
        content.textAlignment = .center
        content.numberOfLines = 0
        content.lineBreakMode = .byWordWrapping
        return content
    }()
    
    lazy var person: UIStackView = {
        let person = UIStackView()
        person.addArrangedSubview(profileImage)
        person.addArrangedSubview(owner)
        return person
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(person)
        stackView.addArrangedSubview(postImage)
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(date)
        //stackView.addArrangedSubview(content)
        stackView.axis = .vertical
        return stackView
    }()
    
    lazy var postView: UIView = {
        let view = UIView()
        view.addSubview(stackView)
        stackView.snp.makeConstraints { (maker) in
            maker.centerX.trailing.top.equalToSuperview()
        }
        view.backgroundColor = UIColor.white
        return view
    }()
}
