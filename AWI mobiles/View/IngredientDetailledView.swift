//
//  IngredientDetailledView.swift
//  AWI mobiles
//
//  Created by m1 on 21/02/2022.
//

import SwiftUI

struct IngredientDetailledView: View {
    
    @State var ingredient : Ingredient
    
    var intent : IngredientIntent = IngredientIntent()
    var viewModel : IngredientDetailViewModel
    var listViewModel : IngredientsViewModel
    
    init(ingredient : Ingredient, listViewModel : IngredientsViewModel){
        self.ingredient = ingredient
        self.viewModel = IngredientDetailViewModel(model: ingredient)
        self.listViewModel = listViewModel
        intent.addObserver(viewModel : self.viewModel, listViewModel : self.listViewModel)
    }
    var body: some View {
        VStack {
            TextField("Libelle :",text:$ingredient.LIBELLE).onSubmit {
                intent.intentToChange(libelle: ingredient.LIBELLE)
                intent.intentToUpdateList()
            }
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
