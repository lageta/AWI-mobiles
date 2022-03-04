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
    private var addMode : Bool
    
    init(ingredient : Ingredient, listViewModel : IngredientsViewModel, addMode : Bool = false){
        self.addMode = addMode
        self.listViewModel = listViewModel
        self.ingredient = ingredient
        self.viewModel = IngredientDetailViewModel(model: ingredient)
        intent.addObserver(viewModel : self.viewModel, listViewModel : self.listViewModel)

        

    }
    var body: some View {
        VStack {
            TextField("",text:$ingredient.LIBELLE).onSubmit {
                intent.intentToChange(libelle: ingredient.LIBELLE)
                intent.intentToUpdateList()
            }
            TextField("",value:$ingredient.CODE, formatter : NumberFormatter()).onSubmit {
                intent.intentToChange(code: ingredient.CODE)
                intent.intentToUpdateList()
            }
            Text(self.ingredient.UNITE)
            Text(String(self.ingredient.STOCK))
            Text(String(self.ingredient.PRIX_UNITAIRE))
        }
        
        .navigationTitle(addMode ? "Ajouter un ingredient" : self.ingredient.LIBELLE)
    }
       
}

struct IngredientDetailledView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}
