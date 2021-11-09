//
//  LocalTeamScore.swift
//  inft3033.assignment2
//
//  Created by Mitchell, Oliver - mitoj001 on 9/11/21.
//  Copyright © 2021 Oliver Mitchell. All rights reserved.
//

import CoreData

/**
 Contains methods to help manage scores stored locally
 */
class LocalTeamScores {
    /**
     Check if a local team has a score recorded in local data
     - Parameter forTeamId: ID of the team to check
     - Returns: True if the team has a score
     */
    public static func scoreExists(forTeamId id: Int32) -> Bool {
        // Get team and return true if not nil
        return LocalTeamScores.getScore(forTeamId: id) != nil
    }
    
    /**
     Get the recorded score for a specified team ID
     */
    public static func getScore(forTeamId id: Int32) -> TeamScore? {
        // Retrieve all scores
        let scores = LocalTeamScores.getScores()
        
        if let scores = scores {
            // Filter scores by their teamId
            let filteredScores = scores.filter({ (score: TeamScore ) -> Bool in
                return score.teamId == id
            })
            
            // If there has been any matches, return the first match
            if filteredScores.count > 0 {
                return filteredScores[0]
            }
        }
        
        // Return nil as no match found
        return nil
    }
    
    /**
     Gets all local scores
     - Returns: An array of team scores.
     */
    public static func getScores() -> [TeamScore]? {
        let scores: [TeamScore]?
        
        // Try and create team managed object
        do {
            scores = try DataUtils.fetchObject(for: "TeamScore") as? [TeamScore]
        } catch {
            print("Issue retrieving TeamScore managed object: \(error)")
            return nil
        }
        
        return scores
    }
}

