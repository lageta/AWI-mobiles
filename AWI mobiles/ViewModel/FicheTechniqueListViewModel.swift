//
//  FicheTechniqueListViewModel.swift
//  AWI mobiles
//
//  Created by m1 on 04/03/2022.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestore

class FicheTechniqueListViewModel : Subscriber, ObservableObject{
    
    @Published var ficheTechniques : [FicheTechnique]
    @Published var filteredFicheTechniques : [FicheTechnique]
    
    private var firestore = Firestore.firestore()
    
    init(){
        ficheTechniques = []
        filteredFicheTechniques = []
    }
    
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
    
    func fetchData() {
        firestore.collection("Fiche Technique").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
              print("No documents")
              return
            }
            
            self.ficheTechniques = documents.map { queryDocumentSnapshot -> FicheTechnique in
                let data = queryDocumentSnapshot.data()
                var array : [Progression] = []
                let test = data["progression"] as? NSArray ?? []
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
                    id: queryDocumentSnapshot.documentID,
                    intitule: data["intitule"] as? String ?? "",
                    responsable: data["responsable"] as? String ?? "",
                    nbCouvert: data["nbCouvert"] as? Int ?? 0,
                    progression: array,
                    categorie: data["categorie"] as? String ?? "")
                
            }
            self.filteredFicheTechniques = self.ficheTechniques
            
        }
    }
    
    func filterFT(searchText : String){
        if !searchText.isEmpty {
            self.filteredFicheTechniques = self.ficheTechniques.filter{ $0.categorie.contains(searchText) ||
                $0.intitule.contains(searchText) || $0.responsable.contains(searchText)
            }
        }else{
            self.filteredFicheTechniques = self.ficheTechniques
        }
        
    }
    
    typealias Input = FicheTechniqueListIntentState

    typealias Failure = Never
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(_ input: FicheTechniqueListIntentState) -> Subscribers.Demand {
        switch input{
            case .ready: break
            case .ListUpdated:
                self.objectWillChange.send()
        }
        
        return .none
    }
    
}

