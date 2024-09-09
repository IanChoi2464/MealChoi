//
//  Helper.swift
//  MealChoi-v5
//
//  Created by Choi Jihyock on 8/6/24.
//

import Foundation
import SwiftUI
import Firebase

class DiningModel: ObservableObject {
    @Published var dinings: [[String:Any]] = []
    
    init() {
        getData()
    }
    
    func getData() {
        let db = Firestore.firestore()
        db.collection("Columbia University").getDocuments{ snapshot, error in
            if error == nil {
                for doc in snapshot!.documents {
                    DispatchQueue.main.async{ self.dinings.append(doc.data()) }
                }
            }
        }
    }
}

class Services {
    static func getDate_str(date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    static func getDate_date(date: String, format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: date)!
    }
    
    static func isOpen(openHours: [String]) -> Bool {
        for oh in openHours {
            if oh == "Closed Today" { return false }
            let now_str = getDate_str(date: Date(), format: "h:mma")
            let now_date = getDate_date(date: now_str, format: "h:mma")
            let t = oh.firstIndex(of:" ")!
            let a = getDate_date(date: String(oh[...t]), format: "h:mma ")
            let b = getDate_date(date: String(oh[t...]), format: " - h:mma")
            if now_date >= a && now_date < b { return true }
        }
        return false
    }
    
    static func getMealTime(numOfMeals: Int) -> String {
        let now = atoi(getDate_str(date: Date(), format: "Hmm"))
        if numOfMeals == 1 { return "Daily" }
        else if numOfMeals==2 {
            if now > 1500 && now < 2359 { return "Dinner" }
            return "Brunch"
        }
        else {
            if now > 1100 && now <= 1500 { return "Lunch" }
            else if now > 1500 && now < 2359 { return "Dinner" }
            return "Breakfast"
        }
    }
    
    static func getHeight(a: Bool, b: Bool, c: Bool, d: Bool) -> CGFloat {
        var count: CGFloat = 0
        if a { count+=1 }
        if b { count+=1 }
        if c { count+=1 }
        if d { count+=1 }
        return 110 + (35 * count)
    }
    
    static func getArray(numOfMeals: Int) -> Array<String> {
        if numOfMeals==3 { return ["Breakfast", "Lunch", "Dinner"] }
        if numOfMeals==2 { return ["Brunch", "Dinner"] }
        if numOfMeals==1 { return ["Daily"] }
        return []
    }
}

class InteractionManager: NSObject, ObservableObject, UIGestureRecognizerDelegate {
    @Published var isInteracting: Bool = false
    @Published var isGestureAdded: Bool = false
    func addGesture() {
        if !isGestureAdded {
            let gesture = UIPanGestureRecognizer(target: self, action: #selector(onChange(gesture:)))
            gesture.name = "UNIVERSAL"
            gesture.delegate = self
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let window = windowScene.windows.last?.rootViewController else { return }
            window.view.addGestureRecognizer(gesture)
            isGestureAdded = true
        }
    }
    
    func removeGesture() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else{ return }
        guard let window = windowScene.windows.last?.rootViewController else { return }
        window.view.gestureRecognizers?.removeAll(where: { gesture in
            return gesture.name == "UNIVERSAL"
        })
        isGestureAdded = false
    }
    
    @objc
    func onChange(gesture: UIPanGestureRecognizer) {
        isInteracting = (gesture.state == .changed)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    @ViewBuilder
    func offsetX(completion: @escaping(CGFloat) -> ()) -> some View {
        self
            .overlay {
                GeometryReader{ proxy in
                    let minX = proxy.frame(in: .global).minX
                    Color.clear
                        .preference(key: OffsetKey.self, value: minX)
                        .onPreferenceChange(OffsetKey.self) { value in
                            completion(value)
                        }
                }
            }
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path{
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct OnBoardingButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(Color.white)
            .overlay(
                Capsule(style: .continuous)
                    .stroke(Color.white, lineWidth: 3)
            )
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

