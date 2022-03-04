//
//  CoutIntent.swift
//  AWI mobiles
//
//  Created by m1 on 02/03/2022.
//

import Foundation
import Combine

enum CoutIntentState : Equatable{
    case useChargeChanging(Bool)
    case usePercChanging(Bool)
    case coutProdPercChanging(Float)
     case coutProdFixeChanging(Float)
     case tauxPersChanging(Float)
     case tauxForfChanging(Float)
     case coefChargeChanging(Float)
     case coefWithoutChargeChanging(Float)
    
}


struct CoutIntent {
    private var state = PassthroughSubject<CoutIntentState, Never>()
    
    
    func addObserver(viewModel : CoutViewModel){
        self.state.subscribe(viewModel)
      
    }
    
    func intentToChange(useCharge : Bool){
        self.state.send(.useChargeChanging(useCharge))
    }
    func intentToChange(usePerc : Bool){
        self.state.send(.usePercChanging(usePerc))
    }
    func intentToChange(coutProdPerc : Float){
        self.state.send(.coutProdPercChanging(coutProdPerc))
    }
    func intentToChange(coutProdFixe : Float){
        self.state.send(.coutProdFixeChanging(coutProdFixe))
    }
    func intentToChange(tauxPers : Float){
        self.state.send(.tauxPersChanging(tauxPers))
    }
    func intentToChange(tauxForf : Float){
        self.state.send(.tauxForfChanging(tauxForf))
    }
    func intentToChange(coefCharge : Float){
        self.state.send(.coefChargeChanging(coefCharge))
    }
    func intentToChange(coefWithoutCharge : Float){
        self.state.send(.coefWithoutChargeChanging(coefWithoutCharge))
    }
}
