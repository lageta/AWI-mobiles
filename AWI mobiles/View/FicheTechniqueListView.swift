//
//  FicheTechniqueListView.swift
//  AWI mobiles
//
//  Created by m1 on 02/03/2022.
//

import SwiftUI

struct FicheTechniqueListView: View {
    @Binding var showMenu: Bool
    
    @StateObject var ftVM : FicheTechniqueListViewModel = FicheTechniqueListViewModel()

    var body: some View {
        Text("Hello, FT!")
        VStack{
            NavigationView{
                List{
                    ForEach(ftVM.ficheTechniques, id: \.id){
                        ficheTechnique in
                        NavigationLink(destination:FicheTechniqueDetailView(ficheTechnique: ficheTechnique, listViewModel: ftVM)){
                            Text(ficheTechnique.intitule)
                            
                        }
                        
                    }
                }
            }
            .onAppear{
                ftVM.fetchData()
            }
            
        }
    }
}

struct FicheTechniqueListView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}
