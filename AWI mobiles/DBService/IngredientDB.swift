//
//  IngredientDB.swift
//  AWI mobiles
//
//  Created by m1 on 21/02/2022.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct IngredientDB {
    let firestore = Firestore.firestore()

        
 
    func getIngredients()async -> [Ingredient] {
        
         if let data = try? await firestore.collection("Ingredient").getDocuments(){
             
         let ingredients : [Ingredient] = data.documents.map{
             (doc) -> Ingredient in
            return Ingredient(
                code: doc["CODE"] as? Int ?? 0,
                libelle: doc["LIBELLE"] as? String ?? "",
                categorie: doc["CATEGORIE"] as? String ?? "",
                prix_unitaire: doc["PRIX_UNITAIRE"] as? Float ?? 0,
                unite: doc["UNITE"] as? String ?? "",
                stock: doc["STOCK"] as? Int ?? 0,
                allergenes: doc["ALLERGENES"] as? [String] ?? [],
                id: doc.documentID)
           
         }
             
            return ingredients
             
         }
       
        return []
    }
    
    func createIngredient(ingredient : Ingredient){
        firestore.collection("Ingredient").addDocument(data: [
            "CODE" : ingredient.CODE,
            "LIBELLE" : ingredient.LIBELLE,
            "CATEGORIE" : ingredient.CATEGORIE,
            "PRIX_UNITAIRE" : ingredient.PRIX_UNITAIRE,
            "UNITE" : ingredient.UNITE,
            "STOCK" : ingredient.STOCK,
            "ALLERGENES" : ingredient.ALLERGENES
            
        ])
    }
    
    func deleteIngredient(ingredient : Ingredient){
        firestore.collection("Ingredient").document(ingredient.id).delete()
    }
    
    func updateIngredient(ingredient : Ingredient){
        firestore.collection("Ingredient").document(ingredient.id).setData([
            "CODE" : ingredient.CODE,
            "LIBELLE" : ingredient.LIBELLE,
            "CATEGORIE" : ingredient.CATEGORIE,
            "PRIX_UNITAIRE" : ingredient.PRIX_UNITAIRE,
            "UNITE" : ingredient.UNITE,
            "STOCK" : ingredient.STOCK,
            "ALLERGENES" : ingredient.ALLERGENES
            
        ])
    }
}
