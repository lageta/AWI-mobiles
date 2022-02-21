//
//  IngredientDetailledView.swift
//  AWI mobiles
//
//  Created by m1 on 21/02/2022.
//

import SwiftUI

struct IngredientDetailledView: View {
    
    @State var ingredient : Ingredient
    
    init(ingredient : Ingredient){
        self.ingredient = ingredient
    }
    var body: some View {
        VStack {
            Text(self.ingredient.LIBELLE)
            Text(String(self.ingredient.CODE))
            Text(self.ingredient.UNITE)
            Text(String(self.ingredient.STOCK))
            Text(String(self.ingredient.PRIX_UNITAIRE))
        }
        .navigationTitle(self.ingredient.LIBELLE)
    }
       
}

struct IngredientDetailledView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}
