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
    
    lazy var postImage: UIImageView = {
       let image = UIImageView()
        return image
    }()
    
    lazy var firstComment: UILabel = {
        let comment = UILabel()
        comment.textAlignment = .left
        comment.numberOfLines = 0
        comment.lineBreakMode = .byWordWrapping
        comment.backgroundColor = .white
        return comment
    }()
    
    lazy var firstCommentView: UIView = {
       let firstCommentView = UIView()
        firstCommentView.addSubview(firstComment)
        firstComment.snp.makeConstraints { (maker) in
            maker.left.right.bottom.top.equalTo(20)
            maker.right.equalTo(-20)
        }
        return firstCommentView
    }()

    lazy var secondComment: UILabel = {
        let comment = UILabel()
        comment.textAlignment = .left
        comment.numberOfLines = 0
        comment.lineBreakMode = .byWordWrapping
        comment.backgroundColor = .white
        return comment
    }()
    
    lazy var secondCommentView: UIView = {
       let secondCommentView = UIView()
        secondCommentView.addSubview(secondComment)
        secondComment.snp.makeConstraints { (maker) in
            maker.left.top.bottom.equalTo(20)
            maker.right.equalTo(-20)
        }
        return secondCommentView
    }()
    
    lazy var date: UILabel = {
        let date = UILabel()
        date.textAlignment = .right
        date.numberOfLines = 0
        date.lineBreakMode = .byWordWrapping
        return date
    }()
    
    lazy var owner: UILabel = {
        let owner = UILabel()
        owner.textAlignment = .left
        owner.numberOfLines = 0
        owner.lineBreakMode = .byWordWrapping
        return owner
    }()
    
    lazy var header: UIStackView = {
        let header = UIStackView()
        header.addArrangedSubview(owner)
        header.addArrangedSubview(date)
        return header
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
        stackView.addArrangedSubview(header)
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(postImage)
        stackView.addArrangedSubview(content)
        stackView.addArrangedSubview(firstCommentView)
        stackView.addArrangedSubview(secondCommentView)
        stackView.axis = .vertical
        return stackView
    }()
    
    lazy var postView: UIView = {
        let view = UIView()
        view.addSubview(stackView)
        stackView.snp.makeConstraints { (maker) in
            maker.centerX.trailing.top.equalToSuperview()
            maker.bottom.equalToSuperview().offset(-firstCommentView.frame.height - secondCommentView.frame.height - 30)
        }
        view.layer.cornerRadius = 10.0
        view.backgroundColor = .lightGray
        return view
    }()
}
