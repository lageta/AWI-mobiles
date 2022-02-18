//
//  IngredientView.swift
//  AWI mobiles
//
//  Created by m1 on 18/02/2022.
//

import SwiftUI

struct IngredientView: View {
    
     var ingredientList : [Ingredient] = [Ingredient(code: 0, libelle: "Test1", categorie: "Cat1", prix_unitaire: 10, unite: "P", stock: 1, allergenes: ["gluten"], id: "fjiejf")]
    
   
    
    var body: some View {
        VStack {
            List {
                ForEach(ingredientList, id: \.id){
                    ingredient in
                    VStack {
                        Text(ingredient.LIBELLE)
                    }
                }
            }
        }
    }
}

struct IngredientView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientView()
    }
}
