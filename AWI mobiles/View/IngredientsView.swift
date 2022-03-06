//
//  IngredientView.swift
//  AWI mobiles
//
//  Created by m1 on 18/02/2022.
//

import SwiftUI




struct IngredientsView: View {
    
    @Binding var showMenu: Bool
    @State private var searchText : String = ""
    @State private var isShowingdDetail : Bool = false
    var filter = ["Libelle", "Categorie", "Prix", "Stock", "Allergene"]
    @State private var selectedFilter = "Libelle"
    /* var ingredientList : [Ingredient] = [Ingredient(code: 0, libelle: "Test1", categorie: "Cat1", prix_unitaire: 10, unite: "P", stock: 1, allergenes: ["gluten"], id: "fjiejf")]
     
     */
    @StateObject var ingredientVM : IngredientsViewModel = IngredientsViewModel(ingredients:[])
    
    var body: some View {
        
        NavigationView {
            
            
            VStack {
                
                Spacer()
                Picker("", selection: $selectedFilter) {
                    ForEach(filter, id: \.self) {
                        Text($0)
                    }
                }
                Spacer()
                
                
                List {
                    
                    ForEach(ingredientVM.filteredIngredients, id: \.id){
                        ingredient in
                        NavigationLink(destination:IngredientDetailledView(ingredient: ingredient, listViewModel: ingredientVM,addMode: false)){
                            
                         
                            
                             
                             switch selectedFilter{
                             case "Libelle":
                             VStack {
                             HStack {
                             if ingredient.ALLERGENES.isEmpty {
                             Text(ingredient.LIBELLE)
                             }
                             else {
                             Text(ingredient.LIBELLE).bold()
                             }
                            /*
                             Spacer()
                             }
                             HStack {
                             Text("n°\(String(ingredient.CODE))").foregroundColor(.mint)
                             .font(.system(size : 12))
                             Text("|")
                             Text(ingredient.CATEGORIE).foregroundColor(.mint)
                             .font(.system(size : 12))
                             Text("|")
                             Text("stock :\(String(ingredient.STOCK))").foregroundColor(.mint)
                             .font(.system(size : 12))
                             Text("|")
                             
                             Text("\(String(ingredient.PRIX_UNITAIRE))€").foregroundColor(.mint)
                             .font(.system(size : 12))
                             Spacer() */
                             }
                             
                             }
                             
                             case"Categorie":
                                 VStack{
                                     HStack {
                                         Text(ingredient.CATEGORIE)
                                         Spacer()
                                     }
                                     
                                     HStack {
                                         if ingredient.ALLERGENES.isEmpty {
                                             Text(ingredient.LIBELLE).foregroundColor(Color.secondary)
                                             .font(.system(size : 14))
                                         }
                                         else {
                                             Text(ingredient.LIBELLE).foregroundColor(Color.secondary)
                                                 .font(.system(size : 14)).bold()
                                         }
                                         Spacer()
                                     }
                                    
                                        
                                 }
                            
                             
                             case "Prix":
                                 VStack {
                                     HStack {
                                         Text(String(ingredient.PRIX_UNITAIRE))
                                         Spacer()
                                     }
                                     HStack {
                                         if ingredient.ALLERGENES.isEmpty {
                                             Text(ingredient.LIBELLE).foregroundColor(Color.secondary)
                                             .font(.system(size : 14))
                                         }
                                         else {
                                             Text(ingredient.LIBELLE).foregroundColor(Color.secondary)
                                                 .font(.system(size : 14)).bold()
                                         }
                                         Spacer()
                                     }
                                 }
                            
                                
                             
                             case "Stock":
                                 VStack{
                                     HStack{
                                         Text(String(ingredient.STOCK))
                                         Spacer()
                                     }
                                     HStack {
                                         if ingredient.ALLERGENES.isEmpty {
                                             Text(ingredient.LIBELLE).foregroundColor(Color.secondary)
                                             .font(.system(size : 14))
                                         }
                                         else {
                                             Text(ingredient.LIBELLE).foregroundColor(Color.secondary)
                                                 .font(.system(size : 14)).bold()
                                         }
                                         Spacer()
                                     }
                                 }
                            
                            
                             
                             
                             case "Allergene":
                             
                                 VStack {
                                     HStack{
                                         ForEach (ingredient.ALLERGENES, id : \.self) {
                                         allergene in
                                         Text(allergene).bold()
                                         
                                         }
                                         Spacer()
                                     }
                                     HStack {
                                         if ingredient.ALLERGENES.isEmpty {
                                             Text(ingredient.LIBELLE).foregroundColor(Color.secondary)
                                             .font(.system(size : 14))
                                         }
                                         else {
                                             Text(ingredient.LIBELLE).foregroundColor(Color.secondary)
                                                 .font(.system(size : 14)).bold()
                                         }
                                         Spacer()
                                     }
                                 }
                            
                           
                             default:
                             
                             Text(ingredient.LIBELLE)
                             
                             
                             
                             }
                            
                        }
                        
                    }
                    .onDelete {
                        indexSet in
                        indexSet.sorted(by: >).forEach { (i) in
                            self.ingredientVM.ingredientDB.deleteIngredient(ingredient: self.ingredientVM.filteredIngredients[i])
                            
                        }
                        
                    }
                    
                    
                    
                    
                }
                
                .listStyle(InsetGroupedListStyle())
                .refreshable{
                    ingredientVM.fetchData()
                }
                
                .navigationTitle("Ingredients")
                
                
                .searchable(text: $searchText, placement : .navigationBarDrawer(displayMode: .always)){
                    ForEach(ingredientVM.filteredIngredients , id : \.id){ result in Text(result.LIBELLE).searchCompletion(result.LIBELLE)
                    }
                    
                }
                EditButton().padding(5)
                HStack{
                    Spacer()
                   
                    NavigationLink(destination:IngredientDetailledView(ingredient: Ingredient(), listViewModel: ingredientVM , addMode: true), isActive: $isShowingdDetail) { EmptyView()}
                    
                    
                    Button (action : {
                        self.isShowingdDetail = true;
                    }){
                        Image(systemName: "plus.circle.fill").font(.largeTitle).foregroundColor(.blue)
                    }
                    
                
                }.padding(10)
              
                
                
            }
        }
        
        
        .onChange(of: searchText){
            index in
            ingredientVM.filterIngredients(searchText : searchText,selectedFilter : selectedFilter)
        }
        .onChange(of: selectedFilter){
            index in
            ingredientVM.filterIngredients(searchText : searchText,selectedFilter : selectedFilter)
            
            
        }/*
          .onChange(of : ingredientVM.ingredients){
          ing in
          ingredientVM.filteredIngredients = ingredientVM.ingredients
          filterIngredients()
          }*/
        /*  .onChange(of: ingredientVM.needToUpdate){
         updt in
         if (ingredientVM.needToUpdate){
         searchCollection = ingredientVM.ingredients
         filterIngredients()
         self.ingredientVM.needToUpdate = false
         }
         }*/
        
        
        .onAppear{
            self.ingredientVM.fetchData()
            ingredientVM.filterIngredients(searchText: searchText, selectedFilter: selectedFilter)
        }
        .pickerStyle(.segmented)
        
    }
}




struct IngredientView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}

