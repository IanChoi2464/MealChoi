//
//  RootView.swift
//  MealChoi-v5
//
//  Created by Choi Jihyock on 8/14/24.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var model1: DiningModel
    var body: some View {
        if model1.dinings.count < 14 {
            WaitingView()
        } else {
            DLMainView()
        }
    }
}

#Preview {
    RootView()
}
