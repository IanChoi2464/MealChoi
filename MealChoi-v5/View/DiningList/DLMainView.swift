//
//  DLHomeView.swift
//  MealChoi-v5
//
//  Created by Choi Jihyock on 8/14/24.
//

import SwiftUI

struct DLMainView: View {
    @EnvironmentObject var model1: DiningModel
    @State var showSideMenu = false
    
    @State private var naturalScrollOffset: CGFloat = 0
    @State private var lastNaturalOffset: CGFloat = 0
    @State private var headerOffset: CGFloat = 0
    @State private var isScrollingUp: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                GeometryReader {
                    let safeArea = $0.safeAreaInsets
                    let headerHeight = 40 + safeArea.top
                    
                    ScrollView(showsIndicators: false) {
                        LazyVStack {
                            ForEach(model1.dinings.indices, id: \.self) { index in
                                let diningName = model1.dinings[index]["name"] as! String
                                let menuInfos = model1.dinings[index]["menuInfos"] as? Dictionary<String,Any> ?? ["":""]
                                let today = model1.dinings[index][Services.getDate_str(date: Date(), format: "yyMMdd")] as! Dictionary<String,Any>
                                let mealTime = Services.getMealTime(numOfMeals: today["numOfMeals"] as? Int ?? 0)
                                let openHours = today["openHours"] as? [String] ?? ["Closed Today"]
                                if index == 9 {
                                    Text("Cafe")
                                        .font(Font.custom("NovaOval", size: 35))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 15)
                                }
                                NavigationLink (
                                    destination: MLMainView(mealTime: mealTime, today: today, menuInfos: menuInfos, diningName: diningName)
                                ){
                                    DLRowView(diningName: diningName, openHours: openHours)
                                }
                            }
                        }
                        .padding(.top)
                        .accentColor(.black)
                    }
                    .safeAreaInset(edge: .top, spacing: 0) {
                        DLHeaderView(showSideMenu: $showSideMenu)
                            .frame(height: headerHeight, alignment: .bottom)
                            .background(.background)
                            .offset(y: -headerOffset)
                    }
                    .onScrollGeometryChange(for: CGFloat.self) { proxy in
                        let maxHeight = proxy.contentSize.height - proxy.containerSize.height
                        return max(min(proxy.contentOffset.y + headerHeight, maxHeight), 0)
                    } action: { oldValue, newValue in
                        let isScrollingUp = oldValue < newValue
                        headerOffset = min(max(newValue - lastNaturalOffset, 0), headerHeight)
                        self.isScrollingUp = isScrollingUp
                        
                        naturalScrollOffset = newValue
                    }
                    .onScrollPhaseChange({ oldPhase, newPhase, context in
                        if !newPhase.isScrolling && (headerOffset != 0 || headerOffset != headerHeight) {
                            withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
                                if headerOffset > (headerHeight * 0.5) && naturalScrollOffset > headerHeight {
                                    headerOffset = headerHeight
                                } else {
                                    headerOffset = 0
                                }
                                
                                lastNaturalOffset = naturalScrollOffset - headerOffset
                            }
                        }
                        
                    })
                    .onChange(of: isScrollingUp, { oldValue, newValue in
                        lastNaturalOffset = naturalScrollOffset - headerOffset
                    })
                    .ignoresSafeArea(.container, edges: .top)
                    
                }
                
                ZStack {
                    GeometryReader { _ in
                        EmptyView()
                    }
                    .background(.gray.opacity(0.25))
                    .opacity(showSideMenu ? 1:0)
                    .animation(.easeIn, value: showSideMenu)
                    //.delay(0.25)
                    .onTapGesture {
                        showSideMenu.toggle()
                    }
                    HStack{
                        Spacer()
                        SMMainView()
                            .frame(width: UIScreen.main.bounds.width / 1.6)
                            .offset(x: showSideMenu ? 0:UIScreen.main.bounds.width)
                            .animation(.default, value: showSideMenu)
                            .cornerRadius(20, corners: [.topLeft, .bottomLeft])
                            .ignoresSafeArea()
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    DLMainView()
}
