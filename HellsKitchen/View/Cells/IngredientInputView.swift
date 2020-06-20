//
//  IngredientView.swift
//  HellsKitchen
//
//  Created by Apple on 20/06/2020.
//  Copyright © 2020 Emil. All rights reserved.
//
import SnapKit
import UIKit

class IngredientInputView: UIView {
    static var delegate: CreatePostViewController?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.addArrangedSubview(field)
        stack.addArrangedSubview(bottomLine)
        field.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
        }
        bottomLine.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
        }
        return stack
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icClose"), for: .normal)
        button.imageView!.tintColor = Constants.Colors.lightGray
        button.snp.makeConstraints { (maker) in
            maker.height.width.equalTo(24)
        }
        return button
    }()
    
    lazy var field: UITextField = {
       let field = UITextField()
        field.placeholder = "new ingredient"
        field.textColor = Constants.Colors.deepGreen
        field.font = UIFont.systemFont(ofSize: 14.0)
        //field.clearButtonMode = .always
        field.rightView = deleteButton
        field.rightViewMode = .always
        if let delegate = IngredientInputView.delegate {
            field.delegate = delegate
        }
        return field
    }()
    
    lazy var bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.lightGray
        view.snp.makeConstraints { (maker) in
            maker.height.equalTo(0.5)
        }
        return view
    }()
    
    func setupView() {
        addSubview(stack)
        stack.snp.makeConstraints { (maker) in
            maker.leading.trailing.top.bottom.equalToSuperview()
        }
    }
}
