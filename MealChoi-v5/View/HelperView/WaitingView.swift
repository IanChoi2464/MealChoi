//
//  WaitingView.swift
//  MealChoi-v5
//
//  Created by Choi Jihyock on 8/14/24.
//

import SwiftUI

struct WaitingView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                Text("MealChoi")
                    .font(Font.custom("NovaOval", size: 50))
                    .foregroundColor(.white)
                Text("For your better college life.")
                    .font(Font.custom("NovaOval", size: 20))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundColor(.white)
                    .padding(.top)
            }
            .padding(.bottom, 150.0)
        }
    }
}

#Preview {
    WaitingView()
}
