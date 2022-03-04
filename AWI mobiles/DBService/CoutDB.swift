//
//  CoutDB.swift
//  AWI mobiles
//
//  Created by m1 on 02/03/2022.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct CoutDB {
    let firestore = Firestore.firestore()

        
 
    func getCout()async -> Cout {
        
        if let data = try? await firestore.collection("Coûts").document("0").getDocument(){
            return Cout(
                useCharge : data["useCharge"] as? Bool ?? false,
                usePerc : data["usePerc"] as? Bool ?? false,
                coutProdPerc : data["coutProdPerc"] as? Float ?? 0.0,
                 coutProdFixe :  data["coutProdFixe"] as? Float ?? 0.0,
                 tauxPers :  data["tauxPers"] as? Float ?? 0.0,
                 tauxForf :  data["tauxForf"] as? Float ?? 0.0,
                 coefCharge :  data["coefCharge"] as? Float ?? 0.0,
                 coefWithoutCharge :  data["coefWithoutCharge"] as? Float ?? 0.0
            )
        }
         return Cout(
            useCharge :  false,
            usePerc : false,
            coutProdPerc :  -1,
             coutProdFixe :  -1,
             tauxPers :   -1,
             tauxForf :  -1,
             coefCharge :  -1,
             coefWithoutCharge :  -1
        )
    }	
    

    
    func updateCout(cout : Cout){
        firestore.collection("Coûts").document("0").setData([
            "useCharge" :  cout.useCharge,
            "usePerc" : cout.usePerc,
            "coutProdPerc" :  cout.coutProdPerc,
            "coutProdFixe" :  cout.coutProdFixe,
            "tauxPers" :   cout.tauxPers,
            "tauxForf" :  cout.tauxForf,
            "coefCharge" :  cout.coefCharge,
            "coefWithoutCharge" :  cout.coefWithoutCharge
            
        ])
    }
    
    func updateSpecificFieldCout(field : CoutProperties, newValue : Any){
        firestore.collection("Coûts").document("0").updateData([
            field.rawValue : newValue
            
        ])
    }
    
    enum CoutProperties : String{
        case useCharge = "useCharge"
        case usePerc = "usePerc"
        case coutProdPerc = "coutProdPerc"
        case coutProdFixe = "coutProdFixe"
        case tauxPers = "tauxPers"
        case tauxForf = "tauxForf"
        case coefCharge = "coefCharge"
        case coefWithoutCharge = "coefWithoutCharge"
    }
}
