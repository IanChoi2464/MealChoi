//
//  MLStationView.swift
//  MealChoi-v5
//
//  Created by Choi Jihyock on 8/14/24.
//

import SwiftUI

struct MLStationView: View {
    @Binding var showDetails: Bool
    @Binding var whichMenu: String
    var sttAndMenus: Dictionary<String, Any>
    var menuInfos: Dictionary<String, Any>
    
    var body: some View {
        let station = sttAndMenus["station"] as! String
        let menus = sttAndMenus["menus"] as! Array<String>
        LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
            Section(header: MLStationHeaderView(station: station)) {
                ForEach(menus, id: \.self) { menu in
                    MLRowView(showDetails: $showDetails, whichMenu: $whichMenu, menu: menu, menuInfos: menuInfos)
                }
            }
        }
    }
}

@ViewBuilder
func MLStationHeaderView(station: String) -> some View {
    ZStack {
        Rectangle()
            .foregroundColor(.white)
            .frame(height: 45)
        Text(station)
            .font(Font.custom("NovaOval", size: 25))
    }
}
