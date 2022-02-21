//
//  IngredientView.swift
//  AWI mobiles
//
//  Created by m1 on 18/02/2022.
//

import SwiftUI

struct IngredientsView: View {
    
    @State private var searchText : String = ""
    
    
    /* var ingredientList : [Ingredient] = [Ingredient(code: 0, libelle: "Test1", categorie: "Cat1", prix_unitaire: 10, unite: "P", stock: 1, allergenes: ["gluten"], id: "fjiejf")]
    
   */
    @StateObject var ingredientVM : IngredientViewModel = IngredientViewModel(ingredients: [])
    @State var searchCollection : [Ingredient] = []
    
    var body: some View {
        NavigationView {
        VStack {
            List {
                ForEach(searchCollection, id: \.id){
                    ingredient in
                    NavigationLink(destination:IngredientDetailledView(ingredient: ingredient)){
                        VStack {
                            Text(ingredient.LIBELLE)
                        }
                    }
                    
                   
                    
                  
                }
              .onDelete {
                    indexState in
                    indexState.sorted(by: >).forEach { (i) in
                        self.ingredientVM.ingredeientDB.deleteIngredient(ingredient: self.searchCollection[i])
                    }
                  
                }
                
            }
            .navigationTitle("Liste des ingrédients")
            .searchable(text: $searchText){
                ForEach(searchCollection , id : \.id){ result in Text(result.LIBELLE).searchCompletion(result.LIBELLE)
                }
            }
            
            EditButton()
        }
        }
        .onChange(of: searchText){
            index in
            filterIngredients()
        }
        .onAppear{
            
            Task {
                 await self.ingredientVM.getIngredients()
                 self.searchCollection = self.ingredientVM.ingredients
               
            }
        }
    }
    
    func filterIngredients(){
            if !searchText.isEmpty {
                self.searchCollection = ingredientVM.ingredients.filter { $0.LIBELLE.contains(searchText) ||
                    $0.CODE==(Int(searchText)) ||
                    $0.PRIX_UNITAIRE==(Float(searchText)) ||
                    $0.STOCK==(Int(searchText)) ||
                    $0.CATEGORIE.contains(searchText) ||
                    $0.UNITE.contains(searchText) ||
                    $0.ALLERGENES.contains(searchText)
                }
            } else {
                self.searchCollection = ingredientVM.ingredients
            }
            
    }
}

struct IngredientView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientsView()
    }
}
