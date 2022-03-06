//
//  IngredientDetailledView.swift
//  AWI mobiles
//
//  Created by m1 on 21/02/2022.
//

import SwiftUI
import Combine

struct IngredientDetailledView: View {
    @State var showingAlert : Bool = false
    @State var ingredient : Ingredient
    @State var allergenes : [SelectedAllergenes]
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
        if !ingredient.ALLERGENES.isEmpty {
            print(ingredient.ALLERGENES[0])
            print(ingredient.ALLERGENES.contains("Céréales contenant du Gluten"))
        }
        self.allergenes = [
            SelectedAllergenes(name: "Céréales contenant du Gluten", isSelected: ingredient.ALLERGENES.contains("Céréales contenant du Gluten")),
            SelectedAllergenes(name:"Arachide", isSelected: ingredient.ALLERGENES.contains("Arachide")),
            SelectedAllergenes(name:"Crustacé", isSelected: ingredient.ALLERGENES.contains("Crustacé")),
            SelectedAllergenes(name:"Céleri", isSelected: ingredient.ALLERGENES.contains("Céleri")),
            SelectedAllergenes(name:"Fruits à coque", isSelected: ingredient.ALLERGENES.contains("Fruits à coque")),
            SelectedAllergenes(name:"Lait", isSelected: ingredient.ALLERGENES.contains("Lait")),
            SelectedAllergenes(name:"Lapin", isSelected: ingredient.ALLERGENES.contains("Lapin")),
            SelectedAllergenes(name:"Mollusques", isSelected: ingredient.ALLERGENES.contains("Mollusques")),
            SelectedAllergenes(name:"Moutarde",isSelected: ingredient.ALLERGENES.contains("Moutarde")),
            SelectedAllergenes(name:"Poisson", isSelected: ingredient.ALLERGENES.contains("Poisson")),
            SelectedAllergenes(name:"Soja", isSelected: ingredient.ALLERGENES.contains("Soja")),
            SelectedAllergenes(name:"Sulfites", isSelected: ingredient.ALLERGENES.contains("Sulfites")),
            SelectedAllergenes(name:"Sésame", isSelected: ingredient.ALLERGENES.contains("Sésame")),
            SelectedAllergenes(name:"Oeuf", isSelected: ingredient.ALLERGENES.contains("Oeuf"))]
    }
    var body: some View {
        VStack {
            
            HStack {
                Spacer()
                FloatingTextFieldView(placeHolder: "Libelle", text: $ingredient.LIBELLE)
                    .onSubmit {
                        if !addMode {
                            intent.intentToChange(libelle: ingredient.LIBELLE)
                            intent.intentToUpdateList()
                        }
                       
                    }
                Spacer()
            }
           
            
            HStack {
                Spacer()
                FloatingTextFieldIntegerView(placeHolder: "Code", text: $ingredient.CODE)
                    .onSubmit {
                        if !addMode {
                            intent.intentToChange(code: ingredient.CODE)
                            intent.intentToUpdateList()
                        }
                        
                    }
                Spacer()
                FloatingTextFieldView(placeHolder : "categorie", text : $ingredient.CATEGORIE).onSubmit {
                    if !addMode{
                        intent.intentToChange(categorie: ingredient.CATEGORIE)
                        intent.intentToUpdateList()
                    }
                    
                }
                Spacer()
            }
           
                
            HStack {
                Spacer()
                FloatingTextFieldView(placeHolder : "Unite", text : $ingredient.UNITE)
                    .onSubmit {
                        if !addMode{
                            intent.intentToChange(unite: ingredient.UNITE)
                            intent.intentToUpdateList()
                        }
                        
                    }
                   Spacer()
                FloatingTextFieldIntegerView(placeHolder : "Stock", text : $ingredient.STOCK).onSubmit {
                    if !addMode{
                        intent.intentToChange(stock: ingredient.STOCK)
                        intent.intentToUpdateList()
                    }
                   
                }
            Spacer()
                FloatingTextFieldFloatView(placeHolder : "prix unitaire", text : $ingredient.PRIX_UNITAIRE).onSubmit {
                    if !addMode {
                        intent.intentToChange(prix_unitaire: ingredient.PRIX_UNITAIRE)
                        intent.intentToUpdateList()
                    }
                    
                }
                Spacer()
            }
               
           
            
       
        
            
            List{
                ForEach(0..<allergenes.count){ index in
                    HStack {
                        Button(action: {
                            allergenes[index].isSelected = allergenes[index].isSelected ? false : true
                            var allergenesToCommit : [String] = []
                            allergenes.forEach{ allergene in
                                if allergene.isSelected {
                                    allergenesToCommit.append(allergene.name)
                                }
                                                }
                            if !addMode {
                            intent.intentToChange(allergenes: allergenesToCommit)
                            intent.intentToUpdateList()
                            }
                        }) {
                            HStack{
                                if allergenes[index].isSelected {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                        .animation(.easeIn)
                                } else {
                                    Image(systemName: "circle")
                                        .foregroundColor(.primary)
                                        .animation(.easeOut)
                                }
                                Text(allergenes[index].name)
                            }
                        }.buttonStyle(BorderlessButtonStyle())
                    }
                }
            }//.listStyle(InsetGroupedListStyle())
            if addMode {
                Button("Submit",action: {
                    self.showingAlert = true
                    }
                )
            }
            
        }
        .alert("Voulez vous créer cet ingredient ?", isPresented: $showingAlert){
            Button("Ok"){}
            
               }
        .navigationTitle(addMode ? "Ajouter un ingredient" : self.ingredient.LIBELLE)
    }
    
    
    
    
}

struct IngredientDetailledView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}
