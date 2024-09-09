//
//  MealChoi_v5App.swift
//  MealChoi-v5
//
//  Created by Choi Jihyock on 8/2/24.
//

import SwiftUI
import Firebase

@main
struct MealChoi_v5App: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(DiningModel())
        }
    }
}
