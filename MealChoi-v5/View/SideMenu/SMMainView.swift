//
//  SMMainView.swift
//  MealChoi-v5
//
//  Created by Choi Jihyock on 8/14/24.
//

import SwiftUI

struct SMMainView: View {
    var body: some View {
        ZStack {
            Color(UIColor(red: 43/255.0, green: 40/255.0, blue: 74/255.0, alpha: 1))
            VStack(alignment: .leading, spacing: 0) {
                Text("Columbia University")
                    .font(Font.custom("NovaOval", size: 25))
                    .foregroundColor(.white)
                    .padding()
                    .padding(.top)
                Rectangle()
                    .foregroundColor(.white)
                    .frame(height: 1)
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                NavigationLink(
                    destination: SMAboutView()
                ){
                    SMRowView()
                }
                Spacer()
            }
            .padding(.top, 15)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

@ViewBuilder
func SMRowView() -> some View {
    VStack {
        HStack {
            Image(systemName: "person.fill.questionmark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32, alignment: .center)
            Text("About")
                .multilineTextAlignment(.leading)
            Spacer()
        }
        .font(Font.custom("Montserrat", size: 18))
        .foregroundColor(.white)
        .padding([.leading])
        Divider()
    }
    
}

@ViewBuilder
func SMAboutView() -> some View {
    ZStack {
        Color(UIColor(red: 43/255.0, green: 40/255.0, blue: 74/255.0, alpha: 1))
        VStack() {
            Text("This app is made by ...")
                .font(Font.custom("NovaOval", size: 23))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.white)
                .padding(.top, 90)
                .padding([.bottom, .leading], 10)
            Image("self")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
                .padding(5)
                .background (
                    Circle()
                        .foregroundColor(.white)
                        .opacity(0.7)
                        .shadow(radius: 5)
                )
            Text("Ian J. Choi")
                .font(Font.custom("NovaOval", size: 30))
                .foregroundColor(.white)
                .padding(.bottom)
            VStack(spacing: 5) {
                Text("Email: workhard2464@gmail.com")
                    .accentColor(.white)
                HStack(spacing: 0) {
                    Text("Instagram: iani_jh")
                    Link(destination: URL(string: "https://www.instagram.com/iani_jh/")!) {
                        Image(systemName: "arrowshape.turn.up.right")
                    }
                }
            }
            .font(Font.custom("Montserrat", size: 17))
            .foregroundColor(.white)
            
            Spacer()
            VStack {
                Text("Information Source")
                HStack(spacing: 0) {
                    Text("Columbia Dining")
                    Link(destination: URL(string: "https://dining.columbia.edu/")!) {
                        Image(systemName: "arrowshape.turn.up.right")
                    }
                }
            }
            .font(Font.custom("Montserrat", size: 17))
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.white)
            .padding(.leading, 10)
            .padding(.bottom, 100)
        }
    }
    .ignoresSafeArea(.all)
}

#Preview {
    SMMainView()
}
