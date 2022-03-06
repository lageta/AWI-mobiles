//
//  FicheTechniqueIntent.swift
//  AWI mobiles
//
//  Created by m1 on 04/03/2022.
//

import Foundation
import Combine

enum FicheTechniqueIntentState : CustomStringConvertible, Equatable{
    static func == (lhs: FicheTechniqueIntentState, rhs: FicheTechniqueIntentState) -> Bool {
        lhs.description == rhs.description
    }
    
    case ready
    case intituleChanging(String)
    case categorieChanging(String)
    case nbCouvertChanging(Int)
    case responsableChanging(String)
    case progressionChanging([Any])
    
    var description: String{
        switch self{
        case .intituleChanging(let intitule):
            return "intitule changing : \(intitule)"
        case .categorieChanging(let categorie):
            return "cateogorie changing : \(categorie)"
        case .nbCouvertChanging(let nb):
            return "nbCouvert changing : \(nb)"
        case .responsableChanging(let responsable):
            return "responsable changing : \(responsable)"
        case .progressionChanging(_):
            return "progression is changing ..."
        default: return "default"
        }
    }
    
}

enum FicheTechniqueListIntentState : Equatable{
    case ready
    case ListUpdated
}

struct FicheTechniqueIntent {
    private var state = PassthroughSubject<FicheTechniqueIntentState, Never>()
    private var stateList = PassthroughSubject<FicheTechniqueListIntentState, Never>()
    
    func addObserver(viewModel : FicheTechniqueDetailViewModel, listViewModel : FicheTechniqueListViewModel){
        self.state.subscribe(viewModel)
        self.stateList.subscribe(listViewModel)
    }
    
    func intentToChange(intitule : String){
        self.state.send(.intituleChanging(intitule))
    }
    func intentToChange(responsable : String){
        self.state.send(.responsableChanging(responsable))
    }
    func intentToChange(nbCouvert : Int){
        self.state.send(.nbCouvertChanging(nbCouvert))
    }
    func intentToChange(progression : [Any]){
        self.state.send(.progressionChanging(progression))
    }
    func intentToChange(categorie : String){
        self.state.send(.categorieChanging(categorie))
    }
    func intentToUpdateList(){
        self.stateList.send(.ListUpdated)
    }
    func ListUpdated(){
        self.stateList.send(.ready)
    }
}
