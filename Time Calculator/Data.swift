//
//  Data.swift
//  Time Calculator
//
//  Created by Liam Loughead on 1/10/24.
//

import Foundation

struct Planet: Hashable {
    var name: String
    var inSS: Bool //In solar system?
    var orbitSpeed: Double // km/s, radial velocity for larger
    var grav: Double // m/s^2
    var radius: Double // KM for planet, LY for larger
    var orbitalPeriodYears: Double
    var drawScale: Double
    var drawDistance: Double
    var massKg: Double //KG for planet, Suns for larger
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

struct PlanetData {
    static var planets = [
        Planet(name: "the Sun", inSS: true, orbitSpeed: 0.0, grav: 274, radius: 696340, orbitalPeriodYears: 0, drawScale: 0.2, drawDistance: 0, massKg: 1.989e30),
        Planet(name: "Mercury", inSS: true, orbitSpeed: 47.9, grav: 3.701, radius: 2439.7, orbitalPeriodYears: (88/365), drawScale: 0.02, drawDistance: 5000, massKg: 3.285e23),
        Planet(name: "Venus", inSS: true, orbitSpeed: 35.0, grav: 8.87, radius: 6051.8, orbitalPeriodYears: (225/365), drawScale: 0.01, drawDistance: 5000, massKg: 4.867e24),
        Planet(name: "Earth", inSS: true, orbitSpeed: 29.8, grav: 9.81, radius: 6378.1, orbitalPeriodYears: 1, drawScale: 0.06, drawDistance: 5000, massKg: 5.972e24),
        Planet(name: "Mars", inSS: true, orbitSpeed: 24.1, grav: 3.71, radius: 3389.5, orbitalPeriodYears: (687/365), drawScale: 0.06, drawDistance: 5000, massKg: 6.39e23),
        Planet(name: "Jupiter", inSS: true, orbitSpeed: 13.1, grav: 24.79, radius: 69911, orbitalPeriodYears: 11.86, drawScale: 0.12, drawDistance: 5000, massKg: 1.898e27),
        Planet(name: "Saturn", inSS: true, orbitSpeed: 9.7, grav: 10.44, radius: 58232, orbitalPeriodYears: 29.4, drawScale: 0.1, drawDistance: 5000, massKg: 5.68e26),
        Planet(name: "Uranus", inSS: true, orbitSpeed: 6.8, grav: 8.87, radius: 25362, orbitalPeriodYears: 84, drawScale: 0.08, drawDistance: 5000, massKg: 8.68e25),
        Planet(name: "Neptune", inSS: true, orbitSpeed: 5.4, grav: 11.15, radius: 24622, orbitalPeriodYears: 165, drawScale: 0.08, drawDistance: 5000, massKg: 1.024e26),
        Planet(name: "Markarian 231", inSS: false, orbitSpeed: 12173.0, grav: 0.0, radius: 185906.66, orbitalPeriodYears: 0.0, drawScale: 2.0, drawDistance: 0.0, massKg: 150e6)
    ]
}

struct Constants {
    static var LightSpeedMeterSeconds: Double = 3*pow(10, 8)
    static var LightSpeedKmSeconds: Double = LightSpeedMeterSeconds/1000.0
    static var GravitationalConstant: Double = 6.6743*pow(10, -11)
    static var SpaceObjDistance: Double = 4000
}
