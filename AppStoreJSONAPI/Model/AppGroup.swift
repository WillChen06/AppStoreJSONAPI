//
//  AppGroup.swift
//  AppStoreJSONAPI
//
//  Created by WillChen on 2022/11/6.
//

import Foundation

struct AppGroup: Decodable {
    let feed: Feed
}

struct Feed: Decodable {
    let title: String
    let results: [FeedResult]
}

struct FeedResult: Decodable, Hashable {
    let id, name, artistName, artworkUrl100: String
}
