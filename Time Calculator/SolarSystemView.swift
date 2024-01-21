//
//  SolarSystemView.swift
//  Time Calculator
//
//  Created by Liam Loughead on 1/8/24.
//

import SwiftUI
import SpriteKit

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}

struct SolarSystemView: View {
    
    @State private var datePicked: Date = Date.now
    private var sSScene: SolarSystemScene = SolarSystemScene()
    private static var astroEpoch = Date(timeIntervalSinceReferenceDate: TimeInterval(exactly: 31557600)!) //Jan 1, 2000
    
    init() {
        sSScene.scaleMode = .resizeFill
        changePlanetPosition()
    }
    
    func changePlanetPosition() {
        var equinox = DateComponents()
        equinox.day = 20
        equinox.month = 3
        equinox.year = datePicked.get(.year)
        if (datePicked < Calendar.current.date(from: equinox)!) { //If the date picked is less than the equinox of this year (like in jan), then use last year equinox
            equinox.year = datePicked.get(.year)-1
        }
        let newEquinoxDate = Calendar.current.date(from: equinox)
        let days = Double(Calendar.current.dateComponents([.day], from: newEquinoxDate!, to: datePicked).day ?? 0)
        sSScene.drawPlanets(date: datePicked)
    }

    var body: some View {
        VStack {
            DatePicker("Date", selection: $datePicked,
                       displayedComponents: [.date]).padding(.all)
            GeometryReader { proxy in
                SpriteView(scene: sSScene)
                    .frame(width: proxy.size.width, height: proxy.size.height)
            }
        }.onChange(of: datePicked) {initial in
            changePlanetPosition()
        }
    }
}

struct SolarSystemView_Previews: PreviewProvider {
    static var previews: some View {
        SolarSystemView()
    }
}
