//
//  ContentView.swift
//  Time Calculator
//
//  Created by Liam Loughead on 1/7/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            SolarSystemView()
                .tabItem {
                    Image(systemName: "globe")
                    Text("Solar System")
                }
            Calculator()
                .tabItem {
                    Image(systemName: "divide.square.fill")
                    Text("Calculator")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
