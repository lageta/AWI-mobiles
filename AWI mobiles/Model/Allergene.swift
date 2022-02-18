//
//  Allergene.swift
//  AWI mobiles
//
//  Created by m1 on 18/02/2022.
//

import Foundation

class Allergene {
    var ingredients : [Ingredient]
    var categorie : String
    
    init(ingredients : [Ingredient], categorie : String){
        self.ingredients = ingredients
        self.categorie = categorie
    }
}
