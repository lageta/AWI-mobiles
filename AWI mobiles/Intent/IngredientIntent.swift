//
//  IngredientIntent.swift
//  AWI mobiles
//
//  Created by m1 on 22/02/2022.
//

import Foundation
import Combine

enum IngredientIntentState : CustomStringConvertible, Equatable{
    case ready
    case codeChanging(Int)
    case libelleChanging(String)
    case categorieChanging(String)
    case uniteChanging(String)
    case stockChanging(Int)
    case prix_unitaireChanging(Double)
    case allergenesChanging([String])
    case createIngredient(Ingredient)
    var description: String{
        switch self{
        default: return ""
        }
    }
    
}

enum IngredientListIntentState : Equatable{
    case ready
    case ListUpdated
}

struct IngredientIntent {
    private var state = PassthroughSubject<IngredientIntentState, Never>()
    private var stateList = PassthroughSubject<IngredientListIntentState, Never>()
    
    func addObserver(viewModel : IngredientDetailViewModel, listViewModel : IngredientsViewModel){
        self.state.subscribe(viewModel)
        self.stateList.subscribe(listViewModel)
    }
    
    func intentToChange(code : Int){
        self.state.send(.codeChanging(code))
    }
    func intentToChange(libelle : String){
        self.state.send(.libelleChanging(libelle))
    }
    func intentToChange(categorie : String){
        self.state.send(.categorieChanging(categorie))
    }
    func intentToChange(unite : String){
        self.state.send(.uniteChanging(unite))
    }
    func intentToChange(stock : Int){
        self.state.send(.stockChanging(stock))
    }
    func intentToChange(prix_unitaire : Double){
        self.state.send(.prix_unitaireChanging(prix_unitaire))
    }
    func intentToChange(allergenes : [String]){
        self.state.send(.allergenesChanging(allergenes))
    }
    func intentToUpdateList(){
        self.stateList.send(.ListUpdated)
    }
    func ListUpdated(){
        self.stateList.send(.ready)
    }
    func intentToCreateIngredient(ingredient : Ingredient){
        self.state.send(.createIngredient(ingredient))
    }
}
