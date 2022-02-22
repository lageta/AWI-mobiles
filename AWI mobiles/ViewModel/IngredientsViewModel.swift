//
//  IngredientViewModel.swift
//  AWI mobiles
//
//  Created by m1 on 18/02/2022.
//

import Foundation
import FirebaseFirestore
import SwiftUI
import Firebase
import Combine

class IngredientsViewModel : ObservableObject, Subscriber {
    
    
 
    
    let ingredientDB = IngredientDB()
    @Published var ingredients : [Ingredient]
    private var firestore = Firestore.firestore()
    init(ingredients : [Ingredient]){
        self.ingredients = ingredients
    }
   
    public func getIngredients() async {
        /*.ingredeientDB.createIngredient(ingredient: Ingredient(code: 99, libelle: "hdd", categorie: "dd", prix_unitaire: 0.5, unite: "d", stock: 45, allergenes: [], id: "pas destring"))*/
        self.ingredients = await ingredientDB.getIngredients()
        self.objectWillChange.send()
    
    }

    func fetchData() {
        firestore.collection("Ingredient").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
              print("No documents")
              return
            }
            
            self.ingredients = documents.map { queryDocumentSnapshot -> Ingredient in
                let data = queryDocumentSnapshot.data()
                return Ingredient(
                    code: data["CODE"] as? Int ?? 0,
                    libelle: data["LIBELLE"] as? String ?? "",
                    categorie: data["CATEGORIE"] as? String ?? "",
                    prix_unitaire: data["PRIX_UNITAIRE"] as? Float ?? 0,
                    unite: data["UNITE"] as? String ?? "",
                    stock: data["STOCK"] as? Int ?? 0,
                    allergenes: data["ALLERGENES"] as? [String] ?? [],
                    id: queryDocumentSnapshot.documentID )
            }
            
        }
        self.objectWillChange.send()
    }
    
    
    
    typealias Input = IngredientListIntentState
    typealias Failure = Never
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(_ input: IngredientListIntentState) -> Subscribers.Demand {
        switch input{
            case .ready: break
            case .ListUpdated:
                self.objectWillChange.send()
        }
        
        return .none
    }


    
}
