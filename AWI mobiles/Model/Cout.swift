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
    
    var coutProdPerc : Float{
        didSet{
            if !(self.coutProdPerc >= 0 && self.coutProdPerc <= 100) {
                self.coutProdPerc = oldValue
            }
            else{
                self.observer?.changed(coutProdPerc: self.coutProdPerc)
            }
        }
    }
    
    var coutProdFixe : Float {
        didSet{
            self.observer?.changed(coutProdFixe: self.coutProdFixe)
        }
    }
    
    var tauxPers : Float {
        didSet{
            self.observer?.changed(tauxPers: self.tauxPers)
        }
    }
    
    var tauxForf : Float {
        didSet{
            self.observer?.changed(tauxForf: self.tauxForf)
        }
    }
    
    var coefCharge : Float{
        didSet{
            self.observer?.changed(coefCharge: self.coefCharge)
        }
    }
    
    var coefWithoutCharge : Float{
        didSet{
            self.observer?.changed(coefWithoutCharge: self.coefWithoutCharge)
        }
    }
    
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
