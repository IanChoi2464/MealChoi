//
//  MLRowView.swift
//  MealChoi-v5
//
//  Created by Choi Jihyock on 8/14/24.
//

import SwiftUI

struct MLRowView: View {
    @Binding var showDetails: Bool
    @Binding var whichMenu: String
    var menu: String
    var menuInfos: Dictionary<String, Any>
    var body: some View {
        VStack(alignment: .leading) {
            let menuInfo = menuInfos[menu] as? Dictionary<String, Any> ?? ["noInfo":true]
            let noInfo = menuInfo["noInfo"] as? Bool ?? false
            Button {
                if !noInfo {
                    showDetails = true
                    whichMenu = menu
                }
            } label: {
                HStack {
                    Text(menu)
                        .font(Font.custom("Roboto", size: 21))
                        .multilineTextAlignment(.leading)
                    Spacer()
                    HStack{
                        if menuInfo["gf"] as? Bool ?? false {
                            Image("Gluten Free")
                                .resizable()
                                .frame(width: 35, height: 35)
                        }
                        if menuInfo["hal"] as? Bool ?? false {
                            Image("Halal")
                                .resizable()
                                .frame(width: 35, height: 35)
                        }
                        if menuInfo["vegan"] as? Bool ?? false {
                            Image("Vegan")
                                .resizable()
                                .frame(width: 35, height: 35)
                        }
                        if menuInfo["vegetarian"] as? Bool ?? false {
                            Image("Vegetarian")
                                .resizable()
                                .frame(width: 35, height: 35)
                        }
                    }
                    .padding(.trailing, 10)
                }
            }
            DividerView()
        }
        .padding(.horizontal, 10.0)
        .foregroundColor(.black)
    }
}
