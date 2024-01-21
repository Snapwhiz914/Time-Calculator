//
//  Calculator.swift
//  Time Calculator
//
//  Created by Liam Loughead on 1/7/24.
//

import SwiftUI
import Combine

//Gravity time dialation: time interval of observed reference frame = time interval of observer * sqrt(
//1-(2*G*mass)/(radius*c^2))
//speed time dialation: time interval of observed reference frame = time interval of observer * sqrt(1-(v^2/c^2)
//unit of time may need to be seconds instead of years

struct Calculator: View {
    @State private var firstPlanet: Planet
    @State private var secondPlanet: Planet
    @State private var numberOfYears: String = "1"
    
    init() {
        self.firstPlanet = PlanetData.planets[3]
        self.secondPlanet = PlanetData.planets[0]
        self.numberOfYears = numberOfYears
    }
    
    private func getSizeMeasurements(planet: Planet) -> (Double, Double) { //mass, radius
        if !planet.inSS {
            print("Not in SS")
            return (planet.massKg*PlanetData.planets[0].massKg, planet.radius*9.461e12) //Suns -> Kg, LY -> KM
        }
        return (planet.massKg, planet.radius)
    }
    
    private func gravTimeRatio() -> Double {
        let planet1Size = getSizeMeasurements(planet: firstPlanet)
        let gravMassCalc1 = 2*Constants.GravitationalConstant*planet1Size.0
        let radiusCalc1 = (planet1Size.1*1000)*pow(Constants.LightSpeedMeterSeconds, 2.0)
        
        let planet2Size = getSizeMeasurements(planet: secondPlanet)
        let gravMassCalc2 = 2*Constants.GravitationalConstant*planet2Size.0
        let radiusCalc2 = (planet2Size.1*1000)*pow(Constants.LightSpeedMeterSeconds, 2.0)
        
        let top = (Double(numberOfYears) ?? 1.0)*sqrt(1-(gravMassCalc1/radiusCalc1))
        let bot = sqrt(1-(gravMassCalc2/radiusCalc2))
        
        let tc2 = ((top/bot)-(Double(numberOfYears) ?? 1.0))
        print(tc2)
        return abs((Double(numberOfYears) ?? 1.0) - tc2) //t1-t2
    }
    
    private func veloTimeRatio() -> Double {
        let veloDiff = abs(self.firstPlanet.orbitSpeed-self.secondPlanet.orbitSpeed) //orbitSpeed in km/s
        let result = (Double(numberOfYears) ?? 1.0)*sqrt(1-(pow(veloDiff*1000, 2)/pow(Constants.LightSpeedMeterSeconds, 2)))
        return result
    }
    
    private func formatTime(diff: Double) -> String {
        let timeInSeconds = diff * 24 * 60 * 60  //Convert years to seconds
        if abs(timeInSeconds) < 60 {
            return numberOfYears + " years, " + timeInSeconds.formatted() + " seconds"
        } else if abs(timeInSeconds) < 3600 {
            let minutes = floor(timeInSeconds / 60)
            return numberOfYears + " years, " + minutes.formatted() + " minutes"
        } else if abs(timeInSeconds) < 86400 {
            let hours = floor(timeInSeconds / 3600)
            return numberOfYears + " years, " + hours.formatted() + " hours"
        } else {
            let days = floor(abs(timeInSeconds) / 86400)
            return numberOfYears + " years, " + days.formatted() + " days"
        }
    }
    
    private var timePassing: String {
        let gravYears = gravTimeRatio()*((Double(numberOfYears) ?? 1.0)*365.25)
        let veloYears = veloTimeRatio()*((Double(numberOfYears) ?? 1.0)*365.25)
        print(gravYears)
        print(veloYears)
        var diff = gravYears-veloYears
        diff *= -1
        return "about " + formatTime(diff: diff)
    }
    
    var body: some View {
        VStack {
            Text("What would you like to calculate?").font(.system(size: 45, weight: .bold))
            VStack {
                Text("If I'm on").font(.system(size: 20))
                Menu {
                    Picker(selection: $firstPlanet) {
                        ForEach(PlanetData.planets, id: \.self) {
                            Text($0.name)
                                .tag($0)
                                .font(.largeTitle)
                        }
                    } label: {}
                } label: {
                    Text(firstPlanet.name)
                        .font(.system(size: 20))
                }
                Text(", how much time passes on ").font(.system(size: 20))
                Menu {
                    Picker(selection: $secondPlanet) {
                        ForEach(PlanetData.planets, id: \.self) {
                            Text($0.name)
                                .tag($0)
                                .font(.largeTitle)
                        }
                    } label: {}
                } label: {
                    Text(secondPlanet.name)
                        .font(.system(size: 20))
                }
                Text("in...").font(.system(size: 20))
                TextField("", text: $numberOfYears)
                    .keyboardType(.numberPad)
                    .font(.system(size: 20))
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.gray, lineWidth: 2.0)
                    )
                    .fixedSize()
                    .onReceive(Just(numberOfYears)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                                self.numberOfYears = filtered
                            }
                        }
                Text("years:").font(.system(size: 20))
                Text(timePassing)
                    .font(.system(size: 20))
            }.padding(.top)
        }
    }
}

struct Calculator_Previews: PreviewProvider {
    static var previews: some View {
        Calculator()
    }
}
