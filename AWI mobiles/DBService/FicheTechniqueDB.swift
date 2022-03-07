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

    
    private func nsdictToEtape(nsdict : NSDictionary) -> Etape{
        var ingredients : [Denree] = []
        let denrees = nsdict["ingredients"] as? NSArray ?? []
        for i in 0..<denrees.count{
            var newIngr : Ingredient = Ingredient()
            var quantite : Double = 0
            if let denree = denrees[i] as? NSDictionary ?? nil {
                quantite = denree["quantite"] as? Double ?? 0
                if let ingr = denree["ingredient"] as? NSDictionary ?? nil{
                    newIngr = Ingredient(
                        code: ingr["CODE"] as? Int ?? 0,
                        libelle: ingr["LIBELLE"] as? String ?? "",
                        categorie: ingr["CATEGORIE"] as? String ?? "",
                        prix_unitaire: ingr["PRIX_UNITAIRE"] as? Double ?? 0,
                        unite: ingr["UNITE"] as? String ?? "",
                        stock: ingr["STOCK"] as? Int ?? 0,
                        allergenes: ingr["ALLERGENES"] as? [String] ?? [],
                        id: ingr["id"] as? String ?? "" )
                }
            }
            ingredients.append(Denree(ingredient: newIngr, quantite: quantite))
        }
        
        return Etape(titreEtape: nsdict["titreEtape"] as? String ?? "",
              description: nsdict["description"] as? String ?? "",
              temps: nsdict["temps"] as? Int ?? 0,
              denrees: ingredients)
    }
    
    private func nsdictToFicheTechnique(nsdict : NSDictionary) -> FicheTechnique{
        var array : [Progression] = []
        let test = nsdict["progression"] as? NSArray ?? []
        if(test.count > 0){
            let test2 = test[0] as? NSDictionary ?? nil
            if let dict = test2{
                if(dict["description"] != nil){
                    let etape = self.nsdictToEtape(nsdict: dict)
                    array.append(etape)
                    
                }else{
                    let ft = self.nsdictToFicheTechnique(nsdict: dict)
                    array.append(ft)
                }
            }
        }
        
        return FicheTechnique(
            id: nsdict["id"] as? String ?? "",
            intitule: nsdict["intitule"] as? String ?? "",
            responsable: nsdict["responsable"] as? String ?? "",
            nbCouvert: nsdict["nbCouvert"] as? Int ?? 0,
            progression: array,
            categorie: nsdict["categorie"] as? String ?? "")
    }
 
    func getFicheTechniques() async -> [FicheTechnique] {
        
        if let data = try? await firestore.collection("Fiche Technique").getDocuments(){
             
            let ficheTechniques : [FicheTechnique] = data.documents.map{
             (doc) -> FicheTechnique in
                
                var array : [Progression] = []
                let test = doc["progression"] as? NSArray ?? []
                if(test.count > 0){
                    let test2 = test[0] as? NSDictionary ?? nil
                    if let dict = test2{
                        if(dict["description"] != nil){
                            let etape = self.nsdictToEtape(nsdict: dict)
                            array.append(etape)
                            
                        }else{
                            let ft = self.nsdictToFicheTechnique(nsdict: dict)
                            array.append(ft)
                        }
                    }
                }
                
                return FicheTechnique(
                    id: doc.documentID,
                    intitule: doc["intitule"] as? String ?? "",
                    responsable: doc["responsable"] as? String ?? "",
                    nbCouvert: doc["nbCouvert"] as? Int ?? 0,
                    progression: array,
                    categorie: doc["categorie"] as? String ?? "")
                
            }
            return ficheTechniques
        }
        return []
    }
    
    func deconstruct(ficheTechnique : FicheTechnique) -> [Any]{
        var test : [Any] = []
        for i in 0..<ficheTechnique.progression.count{
            if(ficheTechnique.progression[i] is FicheTechnique){
                if let ft = ficheTechnique.progression[i] as? FicheTechnique{
                    test.append([
                            "intitule" : ficheTechnique.intitule,
                            "responsable" : ficheTechnique.responsable,
                            "nbCouvert" : ficheTechnique.nbCouvert,
                            "progression" : deconstruct(ficheTechnique: ft),
                            "categorie" : ficheTechnique.categorie])
                }
            }else{
                if let etape = ficheTechnique.progression[i] as? Etape{
                    var denrees: [Any] = []
                    
                    for i in 0..<etape.denrees.count{
                        denrees.append( [
                            "ingredient" : [
                                "id" : etape.denrees[i].ingredient.id,
                                "CODE" : etape.denrees[i].ingredient.CODE,
                                "LIBELLE" : etape.denrees[i].ingredient.LIBELLE,
                                "CATEGORIE" : etape.denrees[i].ingredient.CATEGORIE,
                                "PRIX_UNITAIRE" : etape.denrees[i].ingredient.PRIX_UNITAIRE,
                                "UNITE" : etape.denrees[i].ingredient.UNITE,
                                "STOCK" : etape.denrees[i].ingredient.STOCK,
                                "ALLERGENES" : etape.denrees[i].ingredient.ALLERGENES
                            ],
                            "quantite" : etape.denrees[i].quantite
                        ])
                    }
                    
                    test.append([
                        "titreEtape":etape.titreEtape,
                        "description":etape.description,
                        "temps":etape.temps,
                        "ingredients":denrees
                    ])
                }
            }
        }
        return test
    }
    
    func createFicheTechnique(ficheTechnique : FicheTechnique){
  
       
        
        firestore.collection("Fiche Technique").addDocument(data: [
            "intitule" : ficheTechnique.intitule,
            "responsable" : ficheTechnique.responsable,
            "nbCouvert" : ficheTechnique.nbCouvert,
            "progression" : deconstruct(ficheTechnique: ficheTechnique),
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
            "progression" : deconstruct(ficheTechnique: ficheTechnique),
            "categorie" : ficheTechnique.categorie
            
        ])
        
    }

    func updateFicheTechniqueByIngredientsArray(ingredients : [Ingredient]) async{
        let allFts = await self.getFicheTechniques()
        for ft in allFts{
            for ingredient in ingredients{
                ft.progression = self.exploreAndEditProgression(oldProgression : ft.progression, ingredient: ingredient);
            }
            self.updateFicheTechnique(ficheTechnique: ft)
        }
    }

    func updateFicheTechniqueByIngredients(ingredient : Ingredient) async{
        let allFts = await self.getFicheTechniques()

        for ft in allFts {
            ft.progression = self.exploreAndEditProgression(oldProgression : ft.progression, ingredient : ingredient)
            self.updateFicheTechnique(ficheTechnique : ft)
        }
    }

    private func exploreAndEditProgression(oldProgression : [Progression], ingredient : Ingredient)  -> [Progression]{
        let progression = oldProgression
        for i in 0..<progression.count{
            if(progression[i] is FicheTechnique){
                if let ft = progression[i] as? FicheTechnique{
                    ft.progression = self.exploreAndEditProgression(oldProgression : ft.progression, ingredient : ingredient)
                }
                
            }else{
                if let etape = progression[i] as? Etape{
                    for j in 0..<etape.denrees.count{
                        if(etape.denrees[j].ingredient.id == ingredient.id){
                            etape.denrees[j].ingredient = ingredient
                        }
                    }
                }
            }
        }
        return progression
    }
}
