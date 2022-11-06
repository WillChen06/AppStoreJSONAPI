//
//  Service.swift
//  AppStoreJSONAPI
//
//  Created by WillChen on 2022/11/5.
//

import Foundation

class Service {
    static let shared = Service()
    
    func fetchApps(searchTerm: String) async -> SearchResult? {
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"
        
        guard let url = URL(string: urlString) else { return nil }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let res = response as? HTTPURLResponse, (200...299).contains(res.statusCode) else { return nil }
            let result = try JSONDecoder().decode(SearchResult.self, from: data)
            return result
        } catch {
            print("Error: \(error.localizedDescription)")
            return nil
        }
    }
}
