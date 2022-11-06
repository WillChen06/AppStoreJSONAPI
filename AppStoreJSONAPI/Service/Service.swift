//
//  Service.swift
//  AppStoreJSONAPI
//
//  Created by WillChen on 2022/11/5.
//

import Foundation

class Service {
    static let shared = Service()
    
    // MARK: - Search
    func fetchApps(searchTerm: String) async -> SearchResult? {
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"
        return await fetchGenericJSONData(urlString: urlString)
    }
    
    // MARK: - Apps
    func fetchAppsGroup(from urls: [String]) async -> [AppGroup] {
        await withTaskGroup(of: (index: Int, group: AppGroup?).self, returning: [AppGroup].self) { taskGroup in
            for (i, url) in urls.enumerated() {
                taskGroup.addTask {[weak self] in
                    (i, await self?.fetchGenericJSONData(urlString: url))
                }
            }
            
            var appGroups: [AppGroup?] = Array(repeating: AppGroup?.none, count: urls.count)
            for await result in taskGroup {
                appGroups[result.index] = result.group
            }
            return appGroups.compactMap { $0 }
        }
    }

    func fetchSocialApps() async -> [SocialApp] {
        let urlString = "https://api.letsbuildthatapp.com/appstore/social"
        return await fetchGenericJSONData(urlString: urlString) ?? []
    }
    
    private func fetchGenericJSONData<T: Decodable>(urlString: String) async -> T? {
        guard let url = URL(string: urlString) else { return T?.none }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let res = response as? HTTPURLResponse, (200...299).contains(res.statusCode) else { return T?.none }
            let result = try JSONDecoder().decode(T.self, from: data)
            return result
        } catch {
            print("Error: \(error.localizedDescription)")
            return T?.none
        }
    }
}
