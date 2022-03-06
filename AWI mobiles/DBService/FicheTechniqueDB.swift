//
//  FicheTechniqueDB.swift
//  AWI mobiles
//
//  Created by m1 on 04/03/2022.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct FicheTechniqueDB {
    let firestore = Firestore.firestore()

        
 
    func getFicheTechniques() async -> [FicheTechnique] {
        
        if let data = try? await firestore.collection("Fiche Technique").getDocuments(){
             
            let ficheTechniques : [FicheTechnique] = data.documents.map{
             (doc) -> FicheTechnique in
             return FicheTechnique(
                 id: doc.documentID,
                 intitule: doc["intitule"] as? String ?? "",
                 responsable: doc["responsable"] as? String ?? "",
                 nbCouvert: doc["nbCouvert"] as? Int ?? 0,
                 progression: doc["progression"] as? [Any] ?? [],
                 categorie: doc["categorie"] as? String ?? "")

            }
            return ficheTechniques
        }
        return []
    }
    
    func createFicheTechnique(ficheTechnique : FicheTechnique){
        firestore.collection("Fiche Technique").addDocument(data: [
            "intitule" : ficheTechnique.intitule,
            "responsable" : ficheTechnique.responsable,
            "nbCouvert" : ficheTechnique.nbCouvert,
            "progression" : ficheTechnique.progression,
            "categorie" : ficheTechnique.categorie
        ])
    }
    
    func deleteFicheTechnique(ficheTechnique : FicheTechnique){
        firestore.collection("Fiche Technique").document(ficheTechnique.id).delete()
    }
    
    func updateFicheTechnique(ficheTechnique : FicheTechnique){
        firestore.collection("Fiche Technique").document(ficheTechnique.id).setData([
            "intitule" : ficheTechnique.intitule,
            "responsable" : ficheTechnique.responsable,
            "nbCouvert" : ficheTechnique.nbCouvert,
            "progression" : ficheTechnique.progression,
            "categorie" : ficheTechnique.categorie
            
        ])
    }
}
