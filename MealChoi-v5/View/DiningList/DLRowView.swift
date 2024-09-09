//
//  DLRowView.swift
//  MealChoi-v5
//
//  Created by Choi Jihyock on 8/14/24.
//

import SwiftUI

struct DLRowView: View {
    var diningName: String
    var openHours: [String]
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(15)
                .shadow(radius: 10)
                .aspectRatio(CGSize(width: 335, height: 100), contentMode: .fit)
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text(diningName)
                        .font(Font.custom("Montserrat", size: 26))
                        .foregroundColor(Color(red: 0.204, green: 0.558, blue: 0.871))
                        .bold()
                    HStack {
                        if(Services.isOpen(openHours: openHours)) {
                            Text("Open")
                                .foregroundColor(.green)
                        } else {
                            Text("Closed")
                                .foregroundColor(.red)
                        }
                        VStack {
                            ForEach(openHours, id: \.self) { oh in
                                Text(oh)
                            }
                        }
                    }
                }
            }
            .padding(.leading)
        }
        .padding([.horizontal], 10.0)
    }
}
