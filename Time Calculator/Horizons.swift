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
    let planetNamesAndIDs = ["Mercury": 199,
                             "Venus": 299,
                             "Earth": 399,
                             "Mars": 499,
                             "Jupiter": 599,
                             "Saturn": 699,
                             "Uranus": 799,
                             "Neptune": 899]
    let numberFormatter = NumberFormatter()
    
    init() {
        numberFormatter.numberStyle = .scientific
    }
    
    /**
    Takes a date and turns it to "yyyy-MM-dd" for horizons
     */
    private func getDateStringForAPI(date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df.string(from: date)
    }
    
    /**
    Makes the http call and returns a 2d array of arrays of length 2 of doubles of distances from sun in AU.
     If there is a request error, check the cache for a previously requested datapoint
     */
    public func getXYInAU(startDate: Date, endDate: Date, planet: Planet, callback: @escaping (([[Double]]) -> Void)) {
        let url = URL(string: "https://ssd.jpl.nasa.gov/api/horizons.api?format=json&COMMAND='\(planetNamesAndIDs[planet.name]!)'&OBJ_DATA='NO'&MAKE_EPHEM='YES'&EPHEM_TYPE='VECTORS'&CENTER='500@10'&START_TIME='\(getDateStringForAPI(date: startDate))'&STOP_TIME='\(getDateStringForAPI(date: endDate))'&STEP_SIZE='1%20d'&VEC_TABLE='1x'&CSV_FORMAT='YES'&OUT_UNITS='AU-D'")!
        
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
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                let raw = json!["result"] as! String
                callback(self.interpretHorizonData(rawResultString: raw))
            } catch {
                print("Error decoding JSON: \(error), data: \(String(data: data, encoding: .utf8))")
            }
        }
        
        task.resume()
    }
    
    /**
    Helper method to parse the data from horizons
     */
    private func interpretHorizonData(rawResultString: String) -> ([[Double]]) {
        let csvList = rawResultString.slice(from: "$$SOE", to: "$$EOE")
        
        var array = [[Double]]()
        for line in csvList!.split(separator: "\n") {
            var i = 0
            var toAdd = [Double]()
            for value in line.split(separator: ",") {
                if i == 2 {
                    toAdd.append(Double(numberFormatter.number(from: String(value))!))
                }
                if i == 3 {
                    toAdd.append(Double(numberFormatter.number(from: String(value))!))
                }
                i += 1
            }
            array.append(toAdd)
        }
        
        return array
    }
}
