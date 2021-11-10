//
//  StringExt.swift
//  inft3033.assignment2
//
//  Created by Mitchell, Oliver - mitoj001 on 6/11/21.
//  Copyright © 2021 Oliver Mitchell. All rights reserved.
//

/**
 Utilities for manipulating strings
 */
class StringUtils {
    /**
     Unit of measure for points
     */
    public static var PointsUnit = "pts"
    
    /**
     Placeholder to use when no points have been marked
     */
    public static var NoPointsPlaceholder = "Zero"
    
    /**
     Returns a string representing points
     - Parameter of: Points to get the string of
     - Returns: A points string
     */
    public static func pointsString(of points: Int) -> String {
        return points == 0 ? StringUtils.NoPointsPlaceholder : "\(points) \(StringUtils.PointsUnit)"
    }
    
    /**
     Returns a string representing a place (1st, 2nd etc)
     - Parameter of: Place to get the string of
     - Returns: A place string
     */
    public static func placeString(of place: Int) -> String {
        let lastDigit = place % 10
        
        // Return placeholder if place invalid
        if place <= 0 {
            return "-"
        }
        
        // For 'firsts'
        if lastDigit == 1 {
            return "\(place)st"
        }
        
        // For 'seconds'
        if lastDigit == 2 {
            return "\(place)nd"
        }
        
        // For 'thirds'
        if lastDigit == 3 {
            return "\(place)rd"
        }
        
        // All others
        return "\(place)th"
    }
}
