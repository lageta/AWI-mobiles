//
//  AWI_mobilesApp.swift
//  AWI mobiles
//
//  Created by m1 on 18/02/2022.
//

import SwiftUI
import Firebase

@main
struct AWI_mobilesApp: App {
    var body: some Scene {
        WindowGroup {
            //IngredientsView()
            ContentView()
        }
    }
    
    init(){
        FirebaseApp.configure()
    }
    
}

