//
//  Recipe.swift
//  HellsKitchen
//
//  Created by Aleksandra Brzostek on 5/15/20.
//  Copyright © 2020 Emil. All rights reserved.
//

import Foundation

//MARK: - Recipe
//parameters
struct Recipe: Codable {
    let q: String
    let from, to: Int
    let more: Bool
    let count: Int
    let hits: [Hit]
}

// MARK: - Hit
struct Hit: Codable {
    let recipe: RecipeClass
}

// MARK: - RecipeClass
struct RecipeClass: Codable {
    let uri: String
    let label: String //to chcemy zobaczyc
    let image: String
    let source: String
    let url: String
    let ingredientLines: [String]
    let ingredients: [Ingredient]
    let calories, totalWeight: Double
    let totalTime: Int
}

// MARK: - Ingredient
struct Ingredient: Codable {
    let text: String
    let weight: Double
}
