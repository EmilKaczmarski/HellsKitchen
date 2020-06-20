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
    
    lazy var field: UITextField = {
       let field = UITextField()
        field.placeholder = "new ingredient"
        field.textColor = Constants.Colors.deepGreen
        field.font = UIFont.systemFont(ofSize: 14.0)
        field.clearButtonMode = .unlessEditing
        if let delegate = IngredientInputView.delegate {
            field.delegate = delegate
        }
        return field
    }()
    
    func setupView() {
        addSubview(field)
        field.snp.makeConstraints { (maker) in
            maker.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("aaaaaa")
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
           print("Adsadasjdkanksj")
       }
}
