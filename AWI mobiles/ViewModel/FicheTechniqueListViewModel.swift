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
    
    private var firestore = Firestore.firestore()
    
    init(){
        ficheTechniques = []
    }
    
    func fetchData() {
        firestore.collection("Fiche Technique").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
              print("No documents")
              return
            }
            
            self.ficheTechniques = documents.map { queryDocumentSnapshot -> FicheTechnique in
                let data = queryDocumentSnapshot.data()
                return FicheTechnique(
                    id: queryDocumentSnapshot.documentID,
                    intitule: data["intitule"] as? String ?? "",
                    responsable: data["responsable"] as? String ?? "",
                    nbCouvert: data["nbCouvert"] as? Int ?? 0,
                    progression: data["progression"] as? [Any] ?? [],
                    categorie: data["categorie"] as? String ?? "")
            }
            //self.filteredIngredients = self.ingredients
            
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

