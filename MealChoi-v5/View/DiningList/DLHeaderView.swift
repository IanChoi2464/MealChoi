//
//  DLHeaderView.swift
//  MealChoi-v5
//
//  Created by Choi Jihyock on 8/14/24.
//

import SwiftUI

struct DLHeaderView: View {
    @Binding var showSideMenu: Bool
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text("MealChoi")
                    .font(Font.custom("NovaOval", size: 36))
                    .padding(.leading, 15.0)
                Spacer()
                Button {
                    showSideMenu.toggle()
                } label: {
                    Image(systemName: "line.3.horizontal.circle")
                        .resizable()
                        .frame(width: 30, height: 30, alignment: .center)
                        .padding([.bottom, .trailing], 15.0)
                        .foregroundColor(.blue)
                }
            }
            Divider()
        }
        
    }
}
