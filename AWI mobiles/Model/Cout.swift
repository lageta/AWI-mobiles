//
//  Cout.swift
//  AWI mobiles
//
//  Created by m1 on 18/02/2022.
//

import Foundation

protocol CoutObserver {
    func changed (useCharge : Bool)
    func changed (usePerc :Bool)
    func changed (coutProdPerc : Float)
    func changed (coutProdFixe : Float)
    func changed (tauxPers : Float)
    func changed (tauxForf : Float)
    func changed (coefCharge : Float)
    func changed (coefWithoutCharge : Float)
}

class Cout : ObservableObject{
    
    var observer : CoutObserver?
    
    var useCharge : Bool
    var usePerc : Bool
    var coutProdPerc : Float;
    var coutProdFixe : Float
    var tauxPers : Float
    var tauxForf : Float
    var coefCharge : Float
    var coefWithoutCharge : Float
    
    init(useCharge : Bool,usePerc : Bool,coutProdPerc : Float,coutProdFixe : Float,tauxPers : Float,tauxForf : Float,coefCharge : Float, coefWithoutCharge : Float){
        self.usePerc = usePerc
        self.useCharge = useCharge
        self.coutProdFixe = coutProdFixe
        self.coutProdPerc = coutProdPerc
        self.tauxForf = tauxForf
        self.tauxPers = tauxPers
        self.coefCharge = coefCharge
        self.coefWithoutCharge = coefWithoutCharge
    }
}
