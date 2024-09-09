//
//  MLMainView.swift
//  MealChoi-v5
//
//  Created by Choi Jihyock on 8/14/24.
//

import SwiftUI

struct MLMainView: View {
    @StateObject var gestureManager: InteractionManager = .init()
    @State var offset: CGFloat = 0
    @State var isTapped: Bool = false
    @State var isEntered: Bool = true
    @State var mealTime: String
    @State var showDetails = false
    @State var whichMenu = ""
    var today: Dictionary<String,Any>
    var menuInfos: Dictionary<String,Any>
    var diningName: String
    var body: some View {
        GeometryReader { proxy in
            let screenSize = proxy.size
            let numOfMeals = today["numOfMeals"] as? Int ?? 0
            let mealArray = Services.getArray(numOfMeals:numOfMeals)
            let infoNotProvided = today["infoNotProvided"] as? Bool ?? false
            if numOfMeals == 0 {
                if infoNotProvided {
                    VStack {
                        DynamicTabHeader(mealArray: mealArray, size: screenSize)
                            .offsetX { value in
                                if value > 0 { isEntered = false }
                                else { isEntered = true }
                            }
                        Spacer()
                        Text("Sorry, menu information is not provided.")
                            .font(Font.custom("Montserrat", size: 20))
                        Spacer()
                    }
                    .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
                } else {
                    VStack {
                        DynamicTabHeader(mealArray: mealArray, size: screenSize)
                            .offsetX { value in
                                if value > 0 { isEntered = false }
                                else { isEntered = true }
                            }
                        Spacer()
                        Text("Closed Today")
                            .font(Font.custom("Montserrat", size: 20))
                        Spacer()
                    }
                    .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
                }
            } else {
                ZStack {
                    VStack {
                        DynamicTabHeader(mealArray: mealArray, size: screenSize)
                            .offsetX { value in
                                if value > 0 { isEntered = false }
                                else { isEntered = true }
                            }
                        TabView(selection: $mealTime) {
                            ForEach(mealArray, id: \.self) { tmp in
                                let meal = today[tmp.lowercased()] as! Dictionary<String,Any>
                                ScrollView(showsIndicators: false) {
                                    VStack {
                                        ForEach(Array(meal.keys).indices, id: \.self) { index in
                                            MLStationView(showDetails: $showDetails, whichMenu: $whichMenu, sttAndMenus: meal[String(index + 1)] as! Dictionary<String,Any>, menuInfos: menuInfos)
                                        }
                                    }
                                }
                                .offsetX { value in
                                    if mealTime == tmp && !isTapped && isEntered {
                                        offset = value - (screenSize.width * CGFloat(indexOf(mealArray: mealArray, tmp: tmp)))
                                    }
                                    if value == 0 && isTapped {
                                        isTapped = false
                                    }
                                    if isTapped && gestureManager.isInteracting {
                                        isTapped = false
                                    }
                                }
                                .tag(tmp)
                            }
                        }
                        .ignoresSafeArea()
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .onAppear(perform: gestureManager.addGesture)
                        .onDisappear(perform: gestureManager.removeGesture)
                    }
                    let menuInfo = menuInfos[whichMenu] as? Dictionary<String,Any> ?? ["":""]
                    let showGf = menuInfo["gf"] as? Bool ?? false
                    let showHal = menuInfo["hal"] as? Bool ?? false
                    let showVegan = menuInfo["vegan"] as? Bool ?? false
                    let showVegetarian = menuInfo["vegetarian"] as? Bool ?? false
                    let curHeight = Services.getHeight(a: showGf, b: showHal, c: showVegan, d: showVegetarian)
                    MDMainView(isShowing: $showDetails, whichMenu: whichMenu, showGf: showGf, showHal: showHal, showVegan: showVegan, showVegetarian: showVegetarian, curHeight: curHeight)
                }
                .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
            }
        }
    }
    
    @ViewBuilder
    func DynamicTabHeader(mealArray: Array<String>, size: CGSize) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(diningName)
                .font(Font.custom("NovaOval", size: 35))
                .foregroundColor(.white)
            HStack(spacing: 0) {
                ForEach(mealArray, id: \.self) { tmp in
                    Text(tmp)
                        .font(Font.custom("Roboto", size: 19))
                        .padding(.vertical, 6)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                }
            }
            
            .overlay(alignment: .leading) {
                Capsule()
                    .fill(.white)
                    .overlay(alignment: .leading, content: {
                        GeometryReader { _ in
                            HStack(spacing: 0) {
                                ForEach(mealArray, id: \.self) { tmp in
                                    Text(tmp)
                                        .font(Font.custom("Roboto", size: 19))
                                        .padding(.vertical, 6)
                                        .frame(maxWidth: .infinity)
                                        .foregroundColor(.black)
                                        .contentShape(Capsule())
                                        .onTapGesture {
                                            isTapped = true
                                            withAnimation(.easeInOut) {
                                                mealTime = tmp
                                                offset = -(size.width) * CGFloat(indexOf(mealArray: mealArray, tmp: tmp))
                                            }
                                        }
                                }
                            }
                            .offset(x: -tabOffset(c: CGFloat(mealArray.count), size: size, padding: 30))
                        }
                        .frame(width: size.width - 30)
                    })
                    .frame(width: (mealArray.count > 0) ? (size.width - 30) / CGFloat(mealArray.count):0)
                    .mask({
                        Capsule()
                    })
                    .offset(x: tabOffset(c: CGFloat(mealArray.count), size: size, padding: 30))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding([.horizontal, .bottom], 15)
        .background {
            Rectangle()
                .fill(.ultraThinMaterial)
                .environment(\.colorScheme, .dark)
                .cornerRadius(20, corners:[.bottomLeft, .bottomRight])
                .ignoresSafeArea()
        }
    }
    
    func tabOffset(c: CGFloat,size: CGSize, padding: CGFloat) -> CGFloat {
        return (-offset / size.width) * ((size.width - padding) / c)
    }
    
    func indexOf(mealArray: Array<String>, tmp: String) -> Int {
        let index = mealArray.firstIndex { cur in
            cur == tmp
        } ?? 0
        return index
    }
}
