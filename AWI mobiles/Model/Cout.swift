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
    func changed (coutProdPerc : Double)
    func changed (coutProdFixe : Double)
    func changed (tauxPers : Double)
    func changed (tauxForf : Double)
    func changed (coefCharge : Double)
    func changed (coefWithoutCharge : Double)
}

class Cout : ObservableObject{
    
    var observer : CoutObserver?
    
    var useCharge : Bool
    var usePerc : Bool
    
    var coutProdPerc : Double{
        didSet{
            if !(self.coutProdPerc >= 0 && self.coutProdPerc <= 100) {
                self.coutProdPerc = oldValue
            }
            else{
                self.observer?.changed(coutProdPerc: self.coutProdPerc)
            }
        }
    }
    
    var coutProdFixe : Double {
        didSet{
            self.observer?.changed(coutProdFixe: self.coutProdFixe)
        }
    }
    
    var tauxPers : Double {
        didSet{
            self.observer?.changed(tauxPers: self.tauxPers)
        }
    }
    
    var tauxForf : Double {
        didSet{
            self.observer?.changed(tauxForf: self.tauxForf)
        }
    }
    
    var coefCharge : Double{
        didSet{
            self.observer?.changed(coefCharge: self.coefCharge)
        }
    }
    
    var coefWithoutCharge : Double{
        didSet{
            self.observer?.changed(coefWithoutCharge: self.coefWithoutCharge)
        }
    }
    
    init(useCharge : Bool,usePerc : Bool,coutProdPerc : Double,coutProdFixe : Double,tauxPers : Double,tauxForf : Double,coefCharge : Double, coefWithoutCharge : Double){
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
