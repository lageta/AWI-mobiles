//
//  IngredientDetailViewModel.swift
//  AWI mobiles
//
//  Created by m1 on 22/02/2022.
//

import Foundation
import Combine

class IngredientDetailViewModel : ObservableObject, IngredientObserver, Subscriber{
    
    private var ingredientDB = IngredientDB()
    private var ficheTechniqueDB = FicheTechniqueDB()
    
    typealias Input = IngredientIntentState
    typealias Failure = Never
    
    private var ingredient : Ingredient
    @Published var code : Int
    @Published var libelle : String
    @Published var categorie : String
    @Published var prix_unitaire : Double
    @Published var stock : Int
    @Published var unite : String
    @Published var allergenes : [String]
    
    @Published var intentState : IngredientIntentState
    
    init(model : Ingredient){
        self.ingredient = model
        self.code = model.CODE
        self.libelle = model.LIBELLE
        self.categorie = model.CATEGORIE
        self.prix_unitaire = model.PRIX_UNITAIRE
        self.stock = model.STOCK
        self.unite = model.UNITE
        self.allergenes = model.ALLERGENES
        
        self.intentState = IngredientIntentState.ready
        self.ingredient.observer = self
    }
    
    func changed(code: Int) {
        self.code = code
    }
    
    func changed(libelle: String) {
        self.libelle = libelle
    }
    
    func changed(categorie: String) {
        self.categorie = categorie
    }
    
    func changed(prix_unitaire: Double) {
        self.prix_unitaire = prix_unitaire
    }
    
    func changed(unite: String) {
        self.unite = unite
    }
    
    func changed(stock: Int) {
        self.stock = stock
    }
    
    func changed(allergenes: [String]) {
        self.allergenes = allergenes
    }
    
    func receive(completion : Subscribers.Completion<Never>){
        return
    }
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(_ input: IngredientIntentState) -> Subscribers.Demand {
        self.intentState = input
        
        switch input{
            case .ready : break
            case .codeChanging(let code):
                self.ingredient.CODE = code
                ingredientDB.updateIngredient(ingredient: ingredient)
                Task{
                    await ficheTechniqueDB.updateFicheTechniqueByIngredients(ingredient: ingredient)
                }
            
            case .libelleChanging(let libelle):
                self.ingredient.LIBELLE = libelle
            ingredientDB.updateIngredient(ingredient: ingredient)
            Task{
                await ficheTechniqueDB.updateFicheTechniqueByIngredients(ingredient: ingredient)
            }

            case .categorieChanging(let categorie):
                self.ingredient.CATEGORIE = categorie
            ingredientDB.updateIngredient(ingredient: ingredient)
            Task{
                await ficheTechniqueDB.updateFicheTechniqueByIngredients(ingredient: ingredient)
            }

            case.uniteChanging(let unite):
                self.ingredient.UNITE = unite
            ingredientDB.updateIngredient(ingredient: ingredient)
            Task{
                await ficheTechniqueDB.updateFicheTechniqueByIngredients(ingredient: ingredient)
            }

            case .stockChanging(let stock):
                self.ingredient.STOCK = stock
            ingredientDB.updateIngredient(ingredient: ingredient)
            Task{
                await ficheTechniqueDB.updateFicheTechniqueByIngredients(ingredient: ingredient)
            }

            case .prix_unitaireChanging(let prix_unitaire):
                self.ingredient.PRIX_UNITAIRE = prix_unitaire
            ingredientDB.updateIngredient(ingredient: ingredient)
            Task{
                await ficheTechniqueDB.updateFicheTechniqueByIngredients(ingredient: ingredient)
            }

            case .allergenesChanging(let allergenes):
                self.ingredient.ALLERGENES = allergenes
            ingredientDB.updateIngredient(ingredient: ingredient)
            Task{
                await ficheTechniqueDB.updateFicheTechniqueByIngredients(ingredient: ingredient)
            }

            
        case .createIngredient(let ingredient):
            self.ingredientDB.createIngredient(ingredient: ingredient)

        }
        
        
    
        
        return .none
    }
    
}
