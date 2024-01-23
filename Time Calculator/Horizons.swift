//
//  Horizons.swift
//  Time Calculator
//
//  Created by Liam Loughead on 1/22/24.
//

import Foundation

extension String {
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}

class Horizons {

    var planetNamesAndIDs = ["Mercury": 199,
                             "Venus": 299,
                             "Earth": 399,
                             "Mars": 499,
                             "Jupiter": 599,
                             "Saturn": 699,
                             "Uranus": 799,
                             "Neptune": 899]
    
    init() {
        
    }
    
    private func getDateStringForAPI(date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df.string(from: date)
    }
    
    /**
    Makes the http call and returns a 2d array of arrays of length 2 of doubles of distances from sun in AU.
     If there is a request error, check the cache for a previously requested datapoint
     */
    private func getXYInAU(startDate: Date, endDate: Date, planet: String, callback: (([[Double]]) -> Void)) {
        let url = URL(string: "https://ssd.jpl.nasa.gov/api/horizons.api?format=json&COMMAND='\(planetNamesAndIDs[planet])'&OBJ_DATA='NO'&MAKE_EPHEM='YES'&EPHEM_TYPE='VECTORS'&CENTER='500@10'&START_TIME='\(getDateStringForAPI(startDate))'&STOP_TIME='\(getDateStringForAPI(date: endDate))'&STEP_SIZE='1%20d'&VEC_TABLE='1x'&CSV_FORMAT='YES'&OUT_UNITS='AU-D'")
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                //TODO: cache retrieve
                return
            }
            
            guard let data = data else {
                print("No data received")
                //TODO: cache retrieve
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                callback(interpretHorizonData(jsonObject: json))
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        
        task.resume()
    }
    
    /**
        
     */
    private func interpretHorizonData(jsonObject: Any) -> ([[Double]]) {
        let rawResultString = jsonObject?["result"] as! String
        let csvList = rawResultString.slice(from: "$$SOE", to: "$$EOE")
        
        var array = [[Double]]()
        for line in rawResultString.split(",") {
            var i = 0
            var toAdd = [Double]
            for value in line.split(",") {
                if i == 2 {
                    toAdd[0] = Double(value)
                }
                if i == 3 {
                    toAdd[1] = Double(value)
                }
                i += 1
            }
            array.append(toAdd)
        }
        
        return array
    }
}
