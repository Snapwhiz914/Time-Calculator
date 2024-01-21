//
//  Astronomy.swift
//  Time Calculator
//
//  Created by Liam Loughead on 1/18/24.
//

import Foundation

class Astronomy {
    static func sin(degrees: Double)->Double{
        return __sinpi(degrees/180)
    }
    static func cos(degrees: Double)->Double {
        return __cospi(degrees/180)
    }
    
    static func dateToJulian(date: Date)->Double{
        return 2440587.5 + date.timeIntervalSince1970/86400
    }
    
    static func ecliptic(data: OrbitalElements, xp: Double, yp: Double, zp: Double) -> (Double, Double, Double) {
        let xecl = (cos(degrees:data.w) * cos(degrees:data.node) - sin(degrees:data.w) * sin(degrees:data.node) * cos(degrees:data.I)) * xp + (-sin(degrees:data.w) * cos(degrees:data.node) - cos(degrees:data.w) * sin(degrees:data.node) * cos(degrees:data.I)) * yp
        let yecl = (cos(degrees: data.w) * sin(degrees: data.node) + sin(degrees: data.w) * cos(degrees: data.node) * cos(degrees: data.I)) * xp + (-sin(degrees: data.w) * sin(degrees: data.node) + cos(degrees: data.w) * cos(degrees: data.node) * cos(degrees: data.I)) * yp
        let zecl = sin(degrees:data.w) * sin(degrees:data.I) * xp + cos(degrees:data.w) * sin(degrees:data.I) * yp
        return (xecl, yecl, zecl)
    }
    
    static func planetPosition(date: Date, planet: OrbitalElements)-> (Double, Double, Double){
        let julian = dateToJulian(date: date)
        let T = (julian - 2451545)/36525
        let newA = planet.a + (planet.aCy * T)
        let newE = planet.e + (planet.eCy * T)
        let newI = planet.I + (planet.ICy * T)
        let newL = planet.L + (planet.LCy * T)
        let newW = planet.w + (planet.wCy * T)
        let newNode = planet.node + (planet.nodeCy * T)
        let elements = OrbitalElements(a: newA, e: newE, I: newI, L: newL, w: newW, node: newNode, aCy: 0, eCy: 0, ICy: 0, LCy: 0, wCy: 0, nodeCy: 0)
        
        var oldE = elements.L - (elements.w + elements.node)
        let M = oldE
        var E = M
        let e_star = elements.e * 180/Double.pi
        while abs(E - oldE) > 1/10000 * 180.0/Double.pi {
            oldE = E
            E = M + e_star * self.sin(degrees: oldE)
        }
        let xp = elements.a * (cos(degrees: E) - elements.e)
        let yp = elements.a * sqrt(1 - elements.e * elements.e) * sin(degrees: E)
        let zp:Double = 0
        return ecliptic(data: elements, xp: xp, yp: yp, zp: zp)
    }
}
