//
//  Data.swift
//  Time Calculator
//
//  Created by Liam Loughead on 1/10/24.
//

import Foundation

struct OrbitalElements {
    var a: Double
    var e: Double
    var I: Double
    var L: Double
    var w: Double
    var node: Double
    var aCy: Double
    var eCy: Double
    var ICy: Double
    var LCy: Double
    var wCy: Double
    var nodeCy: Double
}

struct Planet: Hashable {
    var name: String
    var inSS: Bool //In solar system?
    var orbitSpeed: Double // km/s, radial velocity for larger
    var grav: Double // m/s^2
    var radius: Double // KM for planet, LY for larger
    var orbitalPeriodYears: Double
    var avgDistanceMilKm: Double
    var drawScale: Double
    var drawDistance: Double
    var massKg: Double //KG for planet, Suns for larger
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

struct PlanetData {
    static var planets = [
        Planet(name: "the Sun", inSS: true, orbitSpeed: 0.0, grav: 274, radius: 696340, orbitalPeriodYears: 0, avgDistanceMilKm: 0, drawScale: 0.2, drawDistance: 0, massKg: 1.989e30),
        Planet(name: "Mercury", inSS: true, orbitSpeed: 47.9, grav: 3.701, radius: 2439.7, orbitalPeriodYears: (88/365), avgDistanceMilKm: 60.43, drawScale: 0.02, drawDistance: 200, massKg: 3.285e23),
        Planet(name: "Venus", inSS: true, orbitSpeed: 35.0, grav: 8.87, radius: 6051.8, orbitalPeriodYears: (225/365), avgDistanceMilKm: 108, drawScale: 0.01, drawDistance: 350, massKg: 4.867e24),
        Planet(name: "Earth", inSS: true, orbitSpeed: 29.8, grav: 9.81, radius: 6378.1, orbitalPeriodYears: 1, avgDistanceMilKm: 150, drawScale: 0.06, drawDistance: 500, massKg: 5.972e24),
        Planet(name: "Mars", inSS: true, orbitSpeed: 24.1, grav: 3.71, radius: 3389.5, orbitalPeriodYears: (687/365), avgDistanceMilKm: 220.1, drawScale: 0.06, drawDistance: 750, massKg: 6.39e23),
        Planet(name: "Jupiter", inSS: true, orbitSpeed: 13.1, grav: 24.79, radius: 69911, orbitalPeriodYears: 11.86, avgDistanceMilKm: 778, drawScale: 0.12, drawDistance: 1250, massKg: 1.898e27),
        Planet(name: "Saturn", inSS: true, orbitSpeed: 9.7, grav: 10.44, radius: 58232, orbitalPeriodYears: 29.4, avgDistanceMilKm: 1545, drawScale: 0.1, drawDistance: 1750, massKg: 5.68e26),
        Planet(name: "Uranus", inSS: true, orbitSpeed: 6.8, grav: 8.87, radius: 25362, orbitalPeriodYears: 84, avgDistanceMilKm: 2933, drawScale: 0.08, drawDistance: 2250, massKg: 8.68e25),
        Planet(name: "Neptune", inSS: true, orbitSpeed: 5.4, grav: 11.15, radius: 24622, orbitalPeriodYears: 165, avgDistanceMilKm: 4472, drawScale: 0.08, drawDistance: 3000, massKg: 1.024e26),
        Planet(name: "Markarian 231", inSS: false, orbitSpeed: 12173.0, grav: 0.0, radius: 185906.66, orbitalPeriodYears: 0.0, avgDistanceMilKm: 0.0, drawScale: 2.0, drawDistance: 0.0, massKg: 150e6)
    ]
    
    static var orbitalElementsOfPlanets = [
        OrbitalElements(a: 0.0, e: 0.0, I: 0.0, L: 0.0, w: 0.0, node: 0.0, aCy: 0.0, eCy: 0.0, ICy: 0.0, LCy: 0.0, wCy: 0.0, nodeCy: 0.0), //the sun
        OrbitalElements(a: 0.38709927, e: 0.20563593, I: 7.00497902, L: 252.25032350, w: 77.45779628, node: 48.33076593, aCy: 0.00000037, eCy: 0.00001906, ICy: -0.00594749, LCy: 149472.67411175, wCy: 0.16047689, nodeCy: -0.12534081), //Mercury
        OrbitalElements(a: 0.72333566, e: 0.00677672, I: 3.39467605, L: 181.97909950, w: 131.60246718, node: 76.67984255, aCy: 0.00000390, eCy: -0.00004107, ICy: -0.00078890, LCy: 58517.81538729, wCy: 0.00268329, nodeCy: -0.27769418), //Venus
        OrbitalElements(a: 1.00000261, e: 0.01671123, I: -0.00001531, L: 100.46457166, w: 102.93768193, node: 0.0, aCy: 0.00000562, eCy: -0.00004392, ICy: -0.01294668, LCy: 35999.37244981, wCy: 0.32327364, nodeCy: 0.0), //Earth
        OrbitalElements(a: 1.52371034, e: 0.09339410, I: 1.84969142, L: -4.55343205, w: -23.94362959, node: 49.55953891, aCy: 0.00001847, eCy: 0.00007882, ICy: -0.00813131, LCy: 19140.30268499, wCy: 0.44441088, nodeCy: -0.29257343), //Mars
        OrbitalElements(a: 5.20288700, e: 0.04838624, I: 1.30439695, L: 34.39644051, w: 14.72847983, node: 100.47390909, aCy: -0.00011607, eCy: -0.00013253, ICy: -0.00183714, LCy: 3034.74612775, wCy: 0.21252668, nodeCy: 0.20469106), //Jupiter
        OrbitalElements(a: 9.53667594, e: 0.05386179, I: 2.48599187, L: 49.95424423, w: 92.59887831, node: 113.66242448, aCy: -0.00125060, eCy: -0.00050991, ICy: 0.00193609, LCy: 1222.49362201, wCy: -0.41897216, nodeCy: -0.28867794), //Saturn
        OrbitalElements(a: 19.18916464, e: 0.04725744, I: 0.77263783, L: 313.23810451, w: 170.95427630, node: 74.01692503, aCy: -0.00196176, eCy: -0.00004397, ICy: -0.00242939, LCy: 428.48202785, wCy: 0.40805281, nodeCy: 0.04240589), //Uranus
        OrbitalElements(a: 30.06992276, e: 0.00859048, I: 1.77004347, L: -55.12002969, w: 44.96476227, node: 131.78422574, aCy: 0.00026291, eCy: 0.00005105, ICy: 0.00035372, LCy: 218.45945325, wCy: -0.32241464, nodeCy: -0.00508664),//Neptune
        OrbitalElements(a: 0.0, e: 0.0, I: 0.0, L: 0.0, w: 0.0, node: 0.0, aCy: 0.0, eCy: 0.0, ICy: 0.0, LCy: 0.0, wCy: 0.0, nodeCy: 0.0) //Markarian
        
    ]
}

struct Constants {
    static var LightSpeedMeterSeconds: Double = 3*pow(10, 8)
    static var LightSpeedKmSeconds: Double = LightSpeedMeterSeconds/1000.0
    static var GravitationalConstant: Double = 6.6743*pow(10, -11)
    static var SpaceObjDistance: Double = 4000
}
