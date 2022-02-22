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
    @StateObject var ingredientVM : IngredientsViewModel = IngredientsViewModel(ingredients:[])
    @State var searchCollection : [Ingredient] = []
    
    var body: some View {
        VStack {
            HStack(alignment: .bottom){
                Spacer()
                Text("Ingredients").font(.system(size : 40, weight: .black))
                Spacer()
                Spacer()
                
                Button (action : {
                    
                }){
                    Image(systemName: "plus.circle.fill").font(.largeTitle).foregroundColor(.blue)
                }
                Spacer()
            } .padding(5.0)
        
        NavigationView {
            VStack {

                List {
                    ForEach(searchCollection, id: \.id){
                        ingredient in
                        NavigationLink(destination:IngredientDetailledView(ingredient: ingredient, listViewModel: ingredientVM)){
                            VStack {
                                if ingredient.ALLERGENES.isEmpty {
                                    Text(ingredient.LIBELLE)
                                }
                                else {
                                    Text(ingredient.LIBELLE).bold()
                                }
                               
                            }
                        }
                        
                       
                        
                      
                    }
                  .onDelete {
                        indexSet in
                        indexSet.sorted(by: >).forEach { (i) in
                            self.ingredientVM.ingredientDB.deleteIngredient(ingredient: self.searchCollection[i])
                          
                            
                        }
                      
                    }
                    
                }
            
                .searchable(text: $searchText){
                    ForEach(searchCollection , id : \.id){ result in Text(result.LIBELLE).searchCompletion(result.LIBELLE)
                    }
                }
                
                EditButton()
            }
        }
        .padding(.top, 0.0)
            
        .onChange(of: searchText){
            index in
            filterIngredients()
    
        }
        .onChange(of : ingredientVM.ingredients){
            ing in
            searchCollection = ingredientVM.ingredients
            filterIngredients()
            
           
        }
        .onAppear{
            self.ingredientVM.fetchData()
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
