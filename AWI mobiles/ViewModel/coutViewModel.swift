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
   case nameError(String)
   case ramError(Int)
    
    var description: String{
          switch self {
             case .nameError(let name) : return "Error in name : \(name)"
             case .ramError(let ram):    return "Error, ram must be a power of two and \(ram) is not"
             case .noError : return "No error"
          }
       }
    }
   

class CoutViewModel : ObservableObject,Subscriber, CoutObserver  {
    
    let coutDB = CoutDB()
    typealias Input = CoutIntentState
    typealias Failure = Never
    
    @Published var error : CoutViewModelError = .noError
    
    private var cout : Cout
    @Published var useCharge : Bool
    @Published var usePerc : Bool
    @Published var coutProdPerc : Float
    @Published var coutProdFixe : Float
    @Published  var tauxPers : Float
    @Published  var tauxForf : Float
    @Published var coefCharge : Float
    @Published  var coefWithoutCharge : Float
    
    
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
        //self.objectWillChange.send()
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
        case .coefChargeChanging(let coef):
            self.cout.coefCharge = coef
            coutDB.updateSpecificFieldCout(field: .coefCharge, newValue: coef)
            
        case .tauxForfChanging(let taux):
            self.cout.tauxForf = taux
            coutDB.updateSpecificFieldCout(field: .tauxForf, newValue: taux)
            
        case .tauxPersChanging(let taux):
            self.cout.tauxPers = taux
            coutDB.updateSpecificFieldCout(field: .tauxPers, newValue: taux)
            
        case .coutProdFixeChanging(let cout):
            self.cout.coutProdFixe = cout
            coutDB.updateSpecificFieldCout(field: .coutProdFixe, newValue: cout)
            
        case .coutProdPercChanging(let cout):
            self.cout.coutProdPerc = cout
            coutDB.updateSpecificFieldCout(field: .coutProdPerc, newValue: cout)
            
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
    
    func changed(coutProdPerc: Float) {
        self.coutProdPerc = coutProdPerc
    }
    
    func changed(coutProdFixe: Float) {
        self.coutProdFixe = coutProdFixe
    }
    
    func changed(tauxPers: Float) {
        self.tauxPers = tauxPers
    }
    
    func changed(tauxForf: Float) {
        self.tauxForf = tauxForf
    }
    
    func changed(coefCharge: Float) {
        self.coefCharge = coefCharge
        print("hellooooooo")
    }
    
    func changed(coefWithoutCharge: Float) {
        self.coefWithoutCharge = coefWithoutCharge
    }
    
    
}
