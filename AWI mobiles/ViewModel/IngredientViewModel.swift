//
//  IngredientViewModel.swift
//  AWI mobiles
//
//  Created by m1 on 18/02/2022.
//

import Foundation
import FirebaseFirestore

class IngredientViewModel{
    private let firestore = Firestore.firestore()
    
    init(){
        
    }
    
     func getIngredients()async->[Ingredient]{
        let data = try? await firestore.collection("Ingredients").getDocuments()
         let ingredients : [Ingredient] = data?.documents.map{(doc) -> Ingredient in return Ingredient(code: doc.CODE, libelle: doc.LIBELLE, categorie: doc.CATEGORIE, prix_unitaire: doc.PRIX_UNITAIRE, unite: doc.UNITE, stock: doc.STOCK, allergenes: doc.ALLERGENES, id: doc.documentID)
         }

    }
}
