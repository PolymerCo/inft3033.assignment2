//
//  StringExt.swift
//  inft3033.assignment2
//
//  Created by Mitchell, Oliver - mitoj001 on 6/11/21.
//  Copyright © 2021 Oliver Mitchell. All rights reserved.
//

class StringUtils {
    /**
     Returns a string representing points
     - Parameter of: Points to get the string of
     - Returns: A points string
     */
    public static func pointsString(of points: Int) -> String {
        return points == 0 ? Constants.NoPointsPlaceholder : "\(points) \(Constants.PointsUnit)"
    }
    
    /**
     Returns a string representing a place (1st, 2nd etc)
     - Parameter of: Place to get the string of
     - Returns: A place string
     */
    public static func placeString(of place: Int) -> String {
        let lastDigit = place % 10
        
        if place <= 0 {
            return "-"
        }
        
        if lastDigit == 1 {
            return "\(place)st"
        }
        
        if lastDigit == 2 {
            return "\(place)nd"
        }
        
        if lastDigit == 3 {
            return "\(place)rd"
        }
        
        return "\(place)th"
    }
}
