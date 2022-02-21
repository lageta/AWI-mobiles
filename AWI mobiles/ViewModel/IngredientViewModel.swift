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

class IngredientViewModel : ObservableObject {
    let ingredeientDB = IngredientDB()
    var ingredients : [Ingredient]
    
    init(ingredients : [Ingredient]){
        self.ingredients = ingredients
    }
   
    public func getIngredients() async {
        /*.ingredeientDB.createIngredient(ingredient: Ingredient(code: 99, libelle: "hdd", categorie: "dd", prix_unitaire: 0.5, unite: "d", stock: 45, allergenes: [], id: "pas destring"))*/
        self.ingredeientDB.createIngredient(ingredient: Ingredient(code: 107, libelle: "Teessst", categorie: "jjj", prix_unitaire: 0.95, unite: "Nmœ", stock: 367, allergenes: ["gluten","crevettes"], id: "pasdid"))
        self.ingredients = await ingredeientDB.getIngredients()
        self.objectWillChange.send()
    
    }
    //https://peterfriese.dev/posts/swiftui-firebase-fetch-data/#fetching-data-and-subscribing-to-updates
    //Comment in sépare les choses pour qu'on puisse utiliser les servies d'ingrediensts ailleurs ? héritage = le mieux non ?
    /*
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
                id: doc.documentID)
        }
      }
    }
    */
}
