//
//  MenuView.swift
//  AWI mobiles
//
//  Created by m1 on 02/03/2022.
//

import SwiftUI

struct MenuView: View {
    @Binding var selectedView: SelectedView
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "list.bullet.rectangle")
                    .foregroundColor(.gray)
                    .imageScale(.large)
                Button("Fiche techniques", action: {selectedView = .ficheTechnique })
                    .foregroundColor(.gray)
                    .font(.headline)
            }
            .padding(.top, 100)
            HStack {
                Image(systemName: "person")
                    .foregroundColor(.gray)
                    .imageScale(.large)
                // Text("Profile")
                Button("Liste des ingrédients", action: {selectedView = .ingredient })
                    .foregroundColor(.gray)
                    .font(.headline)
            }
            .padding(.top, 30)
           
            HStack {
                Image(systemName: "gear")
                    .foregroundColor(.gray)
                    .imageScale(.large)
                Button("Gestion des coûts", action: {selectedView = .cout })
                    .foregroundColor(.gray)
                    .font(.headline)
            }
            .padding(.top, 30)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 32/255, green: 32/255, blue: 32/255))
        .edgesIgnoringSafeArea(.all)
    }
}

enum SelectedView {
    case ingredient
    case ficheTechnique
    case cout
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}
