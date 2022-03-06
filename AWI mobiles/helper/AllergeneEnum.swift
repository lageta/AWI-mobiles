//
//  AllergeneEnum.swift
//  AWI mobiles
//
//  Created by m1 on 06/03/2022.
//

import Combine

enum AllergeneEnum: Int, CaseIterable, Identifiable {
    case gluten = 0
    case arachide
    case crustace
    case celeri
    case fruitsCoque
    case lait
    case lapin
    case mollusque
    case moutarde
    case poisson
    case soja
    case sulfites
    case sesame
    case oeuf


    var id: AllergeneEnum {
        self
    }

    var literal: String {
        switch self {
        case .gluten : return "Céréales contenant du Gluten"
        case .arachide : return "Arachide"
        case .crustace :return "Crustacé"
        case .celeri : return "Céleri"
        case .fruitsCoque: return "Fruits à coque"
        case .lait: return "Lait"
        case .lapin: return "Lapin"
        case .mollusque: return "Mollusques"
        case .moutarde: return "Moutarde"
        case .poisson: return "Poissons"
        case .soja: return "Soja"
        case .sulfites: return "Sulfites"
        case .sesame: return "Sésame"
        case .oeuf: return "Oeuf"
        }
    }
}
