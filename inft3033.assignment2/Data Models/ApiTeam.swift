//
//  GetTeam.swift
//  inft3033.assignment2
//
//  Created by Mitchell, Oliver - mitoj001 on 7/11/21.
//  Copyright © 2021 Oliver Mitchell. All rights reserved.
//

import Foundation

/**
 Model for a team recieved via API request
 */
struct ApiTeamModel: Codable {
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

/**
 Utility methods for recieving ApiTeamModels via the API server
 */
class ApiTeamRequest {
    
    /**
     URL of the API
     */
    public static var apiUrl = "https://www.partiklezoo.com/freightfrenzy/?"
    
    public static func uploadTeam(withId id: Int32, withName name: String, withLocation location: String, callback: @escaping (Result<Bool, Error>) -> Void) {
        // Check if already exists on API server
        ApiTeamRequest.teamExists(withId: id, callback: { (request) -> Void in
            switch (request) {
            case .success(let exists):
                var url: URL
                
                // Encode all of the parameters so that they are suitable for a URL
                let id: String = "\(id)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
                let name: String = "\(name)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
                let location: String = "\(location)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
                
                // If the user already exists, perform an update action, otherwise, perform a add action
                if exists {
                    url = URL(string: "\(ApiTeamRequest.apiUrl)action=updateteam&id=\(id)&name=\(name)&location=\(location)")!
                } else {
                    url = URL(string: "\(ApiTeamRequest.apiUrl)action=addteam&id=\(id)&name=\(name)&location=\(location)")!
                }
                
                // Create a new URL session
                let session = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                    // If error has occured, run failure callback
                    if let error = error {
                        callback(.failure(error))
                    }
                    
                    // Else, run success callback
                    if data != nil {
                        callback(.success(true))
                    }
                }
                
                // Start session
                session.resume()
            case .failure(let error):
                callback(.failure(error))
            }
        })
    }
    
    /**
     Checks if a team exists on the API server
     - Parameter withID: ID to check
     - Parameter callback: The callback method to call when the request completed
     */
    public static func teamExists(withId id: Int32, callback: @escaping (Result<Bool, Error>) -> Void) -> Void {
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
    public static func getTeam(withId id: Int32, callback: @escaping (Result<ApiTeamModel, Error>) -> Void) -> Void {
        // Encode URL parameters and create URL object
        let id: String = "\(id)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let url = URL(string: "\(ApiTeamRequest.apiUrl)action=team&id=\(id)")!
        
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
                    let json = try JSONDecoder().decode(ApiTeamModel.self, from: data)
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
    public static func getTeams(callback: @escaping (Result<[ApiTeamModel], Error>) -> Void) -> Void {
        // Create URL object
        let url = URL(string: "\(ApiTeamRequest.apiUrl)action=teams")!
        
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
                    let json = try JSONDecoder().decode([ApiTeamModel].self, from: data)
                    callback(.success(json))
                } catch {
                    callback(.failure(error))
                }
            }
        }
        
        // Begin URL session
        session.resume()
    }
}
