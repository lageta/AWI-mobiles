//
//  FicheTechniqueListView.swift
//  AWI mobiles
//
//  Created by m1 on 02/03/2022.
//

import SwiftUI

struct FicheTechniqueListView: View {
    @Binding var showMenu: Bool
    
    @State private var searchText : String = ""
    
    @StateObject var ftVM : FicheTechniqueListViewModel = FicheTechniqueListViewModel()
    @State var isShowingDetail = false
    var body: some View {
        VStack{
            NavigationView{
                List{
                    ForEach(ftVM.filteredFicheTechniques, id: \.id){
                        ficheTechnique in
                        NavigationLink(destination:FicheTechniqueDetailView(ficheTechnique: ficheTechnique, listViewModel: ftVM, isAdding : false)){
                            Text(ficheTechnique.intitule)
                            
                        }
                        
                    }
                    Button (action : {
                        self.isShowingDetail = true;
                    }){
                        Image(systemName: "plus.circle.fill").font(.largeTitle).foregroundColor(.blue)
                    }
                }
                .searchable(text: $searchText, placement : .navigationBarDrawer(displayMode: .always)){
                    ForEach(ftVM.filteredFicheTechniques , id : \.id){ result in Text(result.intitule).searchCompletion(result.intitule)
                    }
                    
                }
                .refreshable{
                    ftVM.fetchData()
                }
                
            }
            
            NavigationLink(destination:FicheTechniqueDetailView(ficheTechnique : FicheTechnique(id: "", intitule: "", responsable: "", nbCouvert: 0, progression: [], categorie: ""), listViewModel: ftVM , isAdding: true), isActive: $isShowingDetail) { EmptyView()}
            
            .onChange(of: searchText){
                index in
                ftVM.filterFT(searchText : searchText)
            }
           
            
           
        }.onAppear{
            ftVM.fetchData()
        }
    }
}

struct FicheTechniqueListView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}
