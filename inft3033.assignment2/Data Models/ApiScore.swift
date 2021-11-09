//
//  ApiScores.swift
//  inft3033.assignment2
//
//  Created by Mitchell, Oliver - mitoj001 on 9/11/21.
//  Copyright © 2021 Oliver Mitchell. All rights reserved.
//

import Foundation


struct ApiScoreModel: Codable {
    /**
     ID of the score record
     */
    public var id: String?
    
    /**
     ID of the team related to the score
     */
    public var teamid: String?
    
    /**
     Score for the autonomous section
     */
    public var autonomous: String?
    
    /**
     Score for the driver controlled section
     */
    public var drivercontrolled: String?
    
    /**
     Score for the endgame section
     */
    public var endgame: String?
    
    /**
     Overall score
     */
    public var score: String?
    
    /**
     Location that the score was made
     */
    public var location: String?
}


class ApiScoreRequest {
    
    /**
     Uploads a score to the API server
     */
    public static func uploadScore(forId id: Int32, autonomous: Int32, drivercontrolled: Int32, endgame: Int32, location: String, callback: @escaping (Result<Bool, Error>) -> Void) {
        let url = URL(string: "\(Constants.apiUrl)action=addscore&teamid=\(id)&autonomous=\(autonomous)&drivercontrolled=\(drivercontrolled)&endgame=\(endgame)&location=\(location)")!
        
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
        
        session.resume()
    }
    
    /**
     Get the position of a score in relation to the other scores stored on the API server
     - Parameter usingScore: The score to check the position of
     - Parameter callback: The callback method to call when the request completed
     */
    public static func getScorePosition(usingScore scoreValue: Int32, callback: @escaping (Result<(position: Int, total: Int), Error>) -> Void) -> Void {
        ApiScoreRequest.getScores(callback: { result -> Void in
            switch result {
            case .success(let scores):
                if scores.count >= 1 {
                    // Sort the scores by the score
                    var sortedScores = scores.sorted {
                        Int32($0.score!)! > Int32($1.score!)!
                    }
                    
                    // Now get the teams from the server
                    ApiTeamRequest.getTeams(callback: { result -> Void in
                        switch result {
                        case .success(let teams):
                            // remove unknown teams from resulting scores, have to do this as the getTeams record is not always accurate
                            // and can contain teams that have been deleted
                            sortedScores = sortedScores.filter({ score -> Bool in
                                return teams.filter({ team -> Bool in
                                    return score.teamid == team.id
                                }).count > 0
                            })
                            
                            // Finally, get the score position
                            // Iterate through sorted scores and find first position where score is greater
                            var position = 1
                            
                            for score in sortedScores {
                                if Int32(score.score!)! > scoreValue {
                                    position += 1
                                } else {
                                    break
                                }
                            }
                            
                            callback(.success((position, sortedScores.count)))
                        case .failure(let error):
                            callback(.failure(error))
                        }
                    })
                } else {
                    callback(.success((1, 1)))
                }
            case .failure(let error):
                callback(.failure(error))
            }
        })
    }
    
    /**
     Gets a team's score from the API server
     - Parameter forTeamId: Score for the team ID
     - Parameter callback: The callback method to call when the request completed
     */
    public static func getScore(forTeamId id: Int32, callback: @escaping (Result<ApiScoreModel?, Error>) -> Void) -> Void {
        ApiScoreRequest.getScores(callback: { result -> Void in
            switch result {
            // If get request was success
            case .success(let scores):
                // Iterate through scores and get team with ID
            
                let filteredScores = scores.filter { score in
                    return Int32(score.teamid!) == id
                }
                
                // return first score if exists, else return nil
                if filteredScores.count > 0 {
                    callback(.success(filteredScores[0]))
                } else {
                    callback(.success(nil))
                }
            case .failure(let error):
                // Pass back failure
                callback(.failure(error))
            }
        })
    }
    
    /**
     Gets all the scores from the API server
     - Parameter callback: The callback method to call when the request completed
     */
    public static func getScores(callback: @escaping (Result<[ApiScoreModel], Error>) -> Void) -> Void {
        let url = URL(string: "\(Constants.apiUrl)")!
        
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
                    let json = try JSONDecoder().decode([ApiScoreModel].self, from: data)
                    callback(.success(json))
                } catch { }
            }
        }
        
        // Begin URL session
        session.resume()
    }
}
