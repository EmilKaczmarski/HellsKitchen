//
//  CreatePostViewModel.swift
//  HellsKitchen
//
//  Created by Apple on 20/06/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit

class CreatePostViewModel {
    var delegate: CreatePostViewController?
    var ingredients = [Ingredient(text: "one", weight: 1),
                       Ingredient(text: "two", weight: 2),
                       Ingredient(text: "three", weight: 3)
                        ]
}
