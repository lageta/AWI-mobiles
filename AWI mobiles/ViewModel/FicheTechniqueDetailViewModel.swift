//
//  FicheTechniqueDetailViewModel.swift
//  AWI mobiles
//
//  Created by m1 on 04/03/2022.
//

import Foundation
import Combine

class FicheTechniqueDetailViewModel : ObservableObject, FicheTechniqueObserver, Subscriber{
    
    private var ficheTechniqueDB = FicheTechniqueDB()
    private var ingredientsDB = IngredientDB()
    
    typealias Input = FicheTechniqueIntentState
    typealias Failure = Never
    
    @Published var ingredients : [Ingredient] = []
    
    private var ficheTechnique : FicheTechnique
    @Published var intitule : String
    @Published var responsable : String
    @Published var nbCouvert : Int
    @Published var progression : [Any]
    @Published var categorie : String
    
    @Published var intentState : FicheTechniqueIntentState
    
    init(model : FicheTechnique){
        self.ficheTechnique = model
        self.intitule = model.intitule
        self.responsable = model.responsable
        self.nbCouvert = model.nbCouvert
        self.progression = model.progression
        self.categorie = model.categorie
        
        self.intentState = FicheTechniqueIntentState.ready
        self.ficheTechnique.observer = self
    }
    
    func getIngredients() async{
        self.ingredients = await ingredientsDB.getIngredients()
    }
    
    func changed(intitule: String) {
        self.intitule = intitule
    }
    
    func changed(responsable: String) {
        self.responsable = responsable
    }
    
    func changed(nbCouvert: Int) {
        self.nbCouvert = nbCouvert
    }
    
    func changed(progression: [Any]) {
        self.progression = progression
    }
    
    func changed(categorie: String) {
        self.categorie = categorie
    }
    
    func receive(completion : Subscribers.Completion<Never>){
        return
    }
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(_ input: FicheTechniqueIntentState) -> Subscribers.Demand {
        self.intentState = input
        switch input{
            case .ready : break
            case .intituleChanging(let intitule):
                self.ficheTechnique.intitule = intitule
            case .responsableChanging(let responsable):
                self.ficheTechnique.responsable = responsable
            case .nbCouvertChanging(let nbCouvert):
                self.ficheTechnique.nbCouvert = nbCouvert
            case.progressionChanging(let progression):
                self.ficheTechnique.progression = progression
            case .categorieChanging(let categorie):
                self.ficheTechnique.categorie = categorie

        }
        
        if(input != .ready){
            ficheTechniqueDB.updateFicheTechnique(ficheTechnique: ficheTechnique)
            print(ficheTechnique.progression)
            
        }
        
        return .none
    }
    
}
