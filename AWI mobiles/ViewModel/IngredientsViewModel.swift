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
  /*  static func == (lhs: IngredientsViewModel, rhs: IngredientsViewModel) -> Bool {
        var isEqual = true
        for i in 0..<lhs.ingredients.count {
            if(lhs.ingredients[i] != rhs.ingredients[i]){
                isEqual = false
            }
        }
        return isEqual
    }*/
    
    
    
 
    
    let ingredientDB = IngredientDB()
    @Published var ingredients : [Ingredient]
    @Published var filteredIngredients : [Ingredient]
    
    
    private var firestore = Firestore.firestore()
    init(ingredients : [Ingredient]){
        self.ingredients = ingredients
        self.filteredIngredients = ingredients
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
            self.filteredIngredients = self.ingredients
            
        }
        
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

    
    func filterIngredients(searchText : String,selectedFilter :String){
        var foo : [Ingredient] = [];
        switch selectedFilter{
            case "Libelle":
                foo  = ingredients.sorted(by: {$0.LIBELLE < $1.LIBELLE})
            case"Categorie":
                foo = ingredients.sorted(by: {$0.CATEGORIE < $1.CATEGORIE})
            case "Prix":
                foo = ingredients.sorted(by: {$0.PRIX_UNITAIRE < $1.PRIX_UNITAIRE})
            case "Stock":
                foo  = ingredients.sorted(by: {$0.STOCK < $1.STOCK})
            case "Allergene":
               foo = ingredients.filter {!$0.ALLERGENES.isEmpty}
            if !foo.isEmpty && foo.count > 2 {
                foo = filteredIngredients.sorted(by: {$0.ALLERGENES[0] < $1.ALLERGENES[0]})
            }
                
                
            default:
                foo = ingredients
        }
        
            if !searchText.isEmpty {
                self.filteredIngredients = foo.filter{ $0.LIBELLE.contains(searchText) ||
                    $0.CODE==(Int(searchText)) ||
                    $0.PRIX_UNITAIRE==(Float(searchText)) ||
                    $0.STOCK==(Int(searchText)) ||
                    $0.CATEGORIE.contains(searchText) ||
                    $0.UNITE.contains(searchText) ||
                    $0.ALLERGENES.contains(searchText)
                }
               
            } else {
                self.filteredIngredients = foo
    
            }
            
    }
    
}
