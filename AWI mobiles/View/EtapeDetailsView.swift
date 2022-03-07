//
//  EtapeDetailsView.swift
//  AWI mobiles
//
//  Created by m1 on 06/03/2022.
//

import SwiftUI

struct EtapeDetailsView: View {
    
    @State var denrees : [Denree]
    
    init(denrees : [Denree]){
        self.denrees = denrees
    }
    
    var body: some View {
        List{
            ForEach(0..<denrees.count){
                i in
                HStack{
                    Text("\(denrees[i].ingredient.LIBELLE)")
                    Text("\(denrees[i].quantite)")
                }
            }
        }
    }
}


struct EtapeDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}
