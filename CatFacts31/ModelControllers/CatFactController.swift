//
//  CatFactController.swift
//  CatFacts31
//
//  Created by Jon Corn on 1/23/20.
//  Copyright © 2020 jdcorn. All rights reserved.
//

import Foundation

class CatFactController {
    
    // MARK: - Properties
    // Create the singleton
    static let shared = CatFactController()
    
    // MARK: - String Helpers
    static private let baseURL = URL(string: "http://catfact.info/api/v1/")
    static private let factsComponent = "facts"
    static private let jsonExtension = "json"
    
    // MARK: - Methods
    static func fetchCatFacts(page: Int, completion: @escaping (Result<[CatFact], NetworkError>) -> Void) {
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL))}
        let factsURL = baseURL.appendingPathComponent(factsComponent).appendingPathExtension(jsonExtension)
        // URLComponents
        var components = URLComponents(url: factsURL, resolvingAgainstBaseURL: true)
        let pageQueryItem = URLQueryItem(name: "page", value: "\(page)")
        components?.queryItems = [pageQueryItem]
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL))}
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print(error, error.localizedDescription)
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data =  data else { return completion(.failure(.noDataFound))}
            
            do {
                let decoder = JSONDecoder()
                let topLevelObject = try decoder.decode(TopLevelGETObject.self, from: data)
                let catFact = topLevelObject.facts
                return completion(.success(catFact))
            } catch {
                print(error, error.localizedDescription)
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    static func postCatFact(details: String, completion: @escaping (Result<CatFact, NetworkError>) -> Void) {
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL))}
        let factURL = baseURL.appendingPathComponent(factsComponent).appendingPathExtension(jsonExtension)
        
        // Create POST method
        var postRequest = URLRequest(url: factURL)
        postRequest.httpMethod = "POST"
        postRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        let postedCatFact = CatFact(id: nil, details: details)
        let ObjectToEncode = TopLevelPOSTObject.init(fact: postedCatFact)
        
        do {
            let encoder = JSONEncoder()
            let catFactData = try encoder.encode(ObjectToEncode)
            postRequest.httpBody = catFactData
        } catch {
            print(error, error.localizedDescription)
            return completion(.failure(.thrownError(error)))
        }
        
        // DataTask
        URLSession.shared.dataTask(with: factURL) { (data, _, error) in
            if let error = error {
                print(error, error.localizedDescription)
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noDataFound))}
            
            do {
                let decoder = JSONDecoder()
                let catFact = try decoder.decode(CatFact.self, from: data)
                return completion(.success(catFact))
            } catch {
                print(error, error.localizedDescription)
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
}
