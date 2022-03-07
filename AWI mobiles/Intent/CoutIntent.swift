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
    case coutProdPercChanging(Double)
     case coutProdFixeChanging(Double)
     case tauxPersChanging(Double)
     case tauxForfChanging(Double)
     case coefChargeChanging(Double)
     case coefWithoutChargeChanging(Double)
    
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
    func intentToChange(coutProdPerc : Double){
        self.state.send(.coutProdPercChanging(coutProdPerc))
    }
    func intentToChange(coutProdFixe : Double){
        self.state.send(.coutProdFixeChanging(coutProdFixe))
    }
    func intentToChange(tauxPers : Double){
        self.state.send(.tauxPersChanging(tauxPers))
    }
    func intentToChange(tauxForf : Double){
        self.state.send(.tauxForfChanging(tauxForf))
    }
    func intentToChange(coefCharge : Double){
        self.state.send(.coefChargeChanging(coefCharge))
    }
    func intentToChange(coefWithoutCharge : Double){
        self.state.send(.coefWithoutChargeChanging(coefWithoutCharge))
    }
}
