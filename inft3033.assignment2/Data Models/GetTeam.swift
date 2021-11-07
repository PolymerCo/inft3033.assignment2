//
//  GetTeam.swift
//  inft3033.assignment2
//
//  Created by Mitchell, Oliver - mitoj001 on 7/11/21.
//  Copyright © 2021 Oliver Mitchell. All rights reserved.
//

import Foundation

/**
 Model for a Get Team request
 */
class GetTeamModel: Codable {
    /**
     ID of the team
     */
    let id: String?
    
    /**
     Name of the team
     */
    let name: String?
    
    /**
     Location of the team
     */
    let location: String?
    
    /**
     Image URL of the team
     */
    let image: String?
    
    /**
     Date created
     */
    let created: String?
    
    /**
     Result of the request
     */
    let result: String?
    
    /**
     Message of the request
     */
    let message: String?
}

class GetTeamRequest {
    
    /**
     Checks if a team exists on the API server
     - Parameter withID: ID to check
     - Parameter callback: The callback method to call when the request completed
     */
    public static func teamExists(withId id: String, callback: @escaping (Result<Bool, Error>) -> Void) -> Void {
        // Run get team request
        getTeam(withId: id, callback: { result -> Void in
            switch result {
            // If get team request was success
            case .success(let model):
                // If model ID is not nil, team must exist
                callback(.success(model.id != nil))
            case .failure(let error):
                // Pass back failure
                callback(.failure(error))
            }
        })
    }
    
    /**
     Gets a team from the API server
     - Parameter withID: ID to get
     - Parameter callback: The callback method to call when the request completed
     */
    public static func getTeam(withId id: String, callback: @escaping (Result<GetTeamModel, Error>) -> Void) -> Void {
        let url = URL(string: "\(Constants.apiUrl)action=team&id=\(id)")!
        
        // Create a new URL session
        let session = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
            // If error has occured, run failure callback
            if let error = error {
                callback(.failure(error))
            }
            
            // Else, run success callback
            if let data = data {
                do {
                    // Decode json object first
                    let json = try JSONDecoder().decode(GetTeamModel.self, from: data)
                    callback(.success(json))
                } catch { }
            }
        }
        
        // Begin URL session
        session.resume()
    }
    
    /**
     Gets teams from the API server
     - Parameter callback: The callback method to call when the request completed
     */
    public static func getTeams(callback: @escaping (Result<[GetTeamModel], Error>) -> Void) -> Void {
        let url = URL(string: "\(Constants.apiUrl)action=teams")!
        
        // Create a new URL session
        let session = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
            // If error has occured, run failure callback
            if let error = error {
                callback(.failure(error))
            }
            
            // Else, run success callback
            if let data = data {
                do {
                    // Decode json object first
                    let json = try JSONDecoder().decode([GetTeamModel].self, from: data)
                    callback(.success(json))
                } catch { }
            }
        }
        
        // Begin URL session
        session.resume()
    }
}
