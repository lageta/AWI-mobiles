//
//  coutViewModel.swift
//  AWI mobiles
//
//  Created by m1 on 02/03/2022.
//

import Foundation
import FirebaseFirestore
import SwiftUI
import Firebase
import Combine


enum CoutViewModelError : Error, CustomStringConvertible, Equatable{
   case noError
    case coutProdPercError(Double)
    case coutProdFixeError(Double)
    case tauxPersError(Double)
    case tauxForfError(Double)
    case  coefChargeError(Double)
    case  coefWithoutChargeError(Double)
    
    var description: String{
        switch self {
        case .coutProdPercError(let cout): return ""
        case .coutProdFixeError(let cout):return ""
        case .tauxPersError(let taux):return ""
        case .tauxForfError(let taux):return ""
        case  .coefChargeError(let taux):return ""
        case .coefWithoutChargeError(let taux):return ""
      
        case .noError : return "No error"
        }
    }
}


class CoutViewModel : ObservableObject,Subscriber, CoutObserver  {
    private var firestore = Firestore.firestore()
    let coutDB = CoutDB()
    typealias Input = CoutIntentState
    typealias Failure = Never
    
    @Published var error : String = CoutViewModelError.noError.description
    
    private var cout : Cout
    @Published var useCharge : Bool
    @Published var usePerc : Bool
    @Published var coutProdPerc : Double
    @Published var coutProdFixe : Double
    @Published  var tauxPers : Double
    @Published  var tauxForf : Double
    @Published var coefCharge : Double
    @Published  var coefWithoutCharge : Double
    
    
    init(model : Cout){
        self.cout = model
        self.usePerc = model.usePerc
        self.useCharge = model.useCharge
        self.coutProdFixe = model.coutProdFixe
        self.coutProdPerc = model.coutProdPerc
        self.tauxForf = model.tauxForf
        self.tauxPers = model.tauxPers
        self.coefWithoutCharge = model.coefWithoutCharge
        self.coefCharge = model.coefCharge
        
        self.cout.observer = self
       
    }
    func changeModel(model : Cout){
        self.cout = model
        self.usePerc = model.usePerc
        self.useCharge = model.useCharge
        self.coutProdFixe = model.coutProdFixe
        self.coutProdPerc = model.coutProdPerc
        self.tauxForf = model.tauxForf
        self.tauxPers = model.tauxPers
        self.coefWithoutCharge = model.coefWithoutCharge
        self.coefCharge = model.coefCharge
        
        self.cout.observer = self
        
    }
    
    func fetchData() {
        firestore.collection("Coûts").addSnapshotListener { (querySnapshot, error) in
            guard let document = querySnapshot?.documents else {
              print("No documents")
              return
            }
            self.cout =  Cout(
                    useCharge : document[0]["useCharge"] as? Bool ?? false,
                    usePerc : document[0]["usePerc"] as? Bool ?? false,
                    coutProdPerc : document[0]["coutProdPerc"] as? Double ?? 0.0,
                     coutProdFixe :  document[0]["coutProdFixe"] as? Double ?? 0.0,
                     tauxPers :  document[0]["tauxPers"] as? Double ?? 0.0,
                     tauxForf :  document[0]["tauxForf"] as? Double ?? 0.0,
                     coefCharge :  document[0]["coefCharge"] as? Double ?? 0.0,
                     coefWithoutCharge :  document[0]["coefWithoutCharge"] as? Double ?? 0.0
                )
           print("cout updated")
            
        }
        
    }
    
    
    
    func receive(completion : Subscribers.Completion<Never>){
        return
    }
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(_ input: CoutIntentState) -> Subscribers.Demand {
        switch input{
            
        case .coefWithoutChargeChanging(let coef):
            self.cout.coefWithoutCharge = coef
            coutDB.updateSpecificFieldCout(field: .coefWithoutCharge, newValue: coef)
            /*
             
             Rajouter les will didset dans le modèle
             et le onChange dans la view
             
             if ram != self.model.ram {
                           print("vm: error detected => set vm error")
                           self.error = .ramError(ram)
                           self.ram = self.model.ram
                           print("vm: error detected => self.ram = '\(self.model.ram)'")
                        }
             */
            if coef != self.cout.coefWithoutCharge {
                self.error = CoutViewModelError.coefWithoutChargeError(coef).description
                self.coefWithoutCharge = self.cout.coefWithoutCharge
            }
            
        case .coefChargeChanging(let coef):
            self.cout.coefCharge = coef
            coutDB.updateSpecificFieldCout(field: .coefCharge, newValue: coef)
            if coef != self.cout.coefCharge {
                self.error = CoutViewModelError.coefChargeError(coef).description
                self.coefCharge = self.cout.coefCharge
            }
            
        case .tauxForfChanging(let taux):
            self.cout.tauxForf = taux
            coutDB.updateSpecificFieldCout(field: .tauxForf, newValue: taux)
            if taux != self.cout.tauxForf {
                self.error = CoutViewModelError.tauxForfError(taux).description
                self.tauxForf = self.cout.tauxForf
            }
            
        case .tauxPersChanging(let taux):
            self.cout.tauxPers = taux
            coutDB.updateSpecificFieldCout(field: .tauxPers, newValue: taux)
            if taux != self.cout.tauxPers {
                self.error = CoutViewModelError.tauxPersError(taux).description
                self.tauxPers = self.cout.tauxPers
            }
            
        case .coutProdFixeChanging(let cout):
            self.cout.coutProdFixe = cout
            coutDB.updateSpecificFieldCout(field: .coutProdFixe, newValue: cout)
            if cout != self.cout.coutProdFixe {
                self.error = CoutViewModelError.coutProdFixeError(cout).description
                self.coutProdFixe = self.cout.coutProdFixe
            }
            
        case .coutProdPercChanging(let cout):
            self.cout.coutProdPerc = cout
            print( cout )
            print(self.coutProdPerc)
            if cout != self.cout.coutProdPerc {
                print("heloo")
                self.error = CoutViewModelError.coutProdPercError(cout).description
                self.coutProdPerc = self.cout.coutProdPerc
                self.objectWillChange.send()
              
            }else {
                coutDB.updateSpecificFieldCout(field: .coutProdPerc, newValue: cout)
            }
            
        case .useChargeChanging(let use):
            self.cout.useCharge = use
            coutDB.updateSpecificFieldCout(field: .useCharge, newValue: use)
            
        case .usePercChanging(let use):
            self.cout.usePerc = use
            coutDB.updateSpecificFieldCout(field: .usePerc, newValue: use)
        }
       
      //  coutDB.updateCout(cout: cout)
        return .none
    }
    
    
    func changed(useCharge: Bool) {
        self.useCharge = useCharge
    }
    
    func changed(usePerc: Bool) {
        self.usePerc = usePerc
    }
    
    func changed(coutProdPerc: Double) {
        self.coutProdPerc = coutProdPerc
    }
    
    func changed(coutProdFixe: Double) {
        self.coutProdFixe = coutProdFixe
    }
    
    func changed(tauxPers: Double) {
        self.tauxPers = tauxPers
    }
    
    func changed(tauxForf: Double) {
        self.tauxForf = tauxForf
    }
    
    func changed(coefCharge: Double) {
        self.coefCharge = coefCharge
    }
    
    func changed(coefWithoutCharge: Double) {
        self.coefWithoutCharge = coefWithoutCharge
    }
    
    
}
