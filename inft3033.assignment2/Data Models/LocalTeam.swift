//
//  Team.swift
//  inft3033.assignment2
//
//  Created by Mitchell, Oliver - mitoj001 on 9/11/21.
//  Copyright © 2021 Oliver Mitchell. All rights reserved.
//

import CoreData

/**
 Contains methods to help manage teams stored locally
 */
class LocalTeam {
    /**
     Check if a local team exists with a given ID
     - Parameter withId: ID of the team to check
     - Returns: True if the team exists
     */
    public static func teamExists(withId id: Int32) -> Bool {
        // Get team and return true if not nil
        return LocalTeam.getTeam(withId: id) != nil
    }
    
    /**
     Retrieves a local team with a specified teamId
     - Parameter withId: Team ID to get
     - Returns: A team with the given teamID
     */
    public static func getTeam(withId id: Int32) -> Team? {
        // Retrieve all teams
        let teams = LocalTeam.getTeams()
        
        if let teams = teams {
            // Filter teams by their teamId
            let filteredTeams = teams.filter({ (team: Team ) -> Bool in
                return team.teamId == id
            })
            
            // If there has been any matches, return the first match
            if filteredTeams.count > 0 {
                return filteredTeams[0]
            }
        }
        
        // Return nil as no match found
        return nil
    }
    
    /**
     Gets all local teams
     - Returns: An array of teams.
     */
    public static func getTeams() -> [Team]? {
        let teams: [Team]?
        
        // Try and create team managed object
        do {
            teams = try DataUtils.fetchObject(for: "Team") as? [Team]
        } catch {
            print("Issue retrieving Team managed object: \(error)")
            return nil
        }
        
        return teams
    }
}
