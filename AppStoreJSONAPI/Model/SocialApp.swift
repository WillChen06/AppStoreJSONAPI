//
//  SocialApp.swift
//  AppStoreJSONAPI
//
//  Created by WillChen on 2022/11/6.
//

import Foundation

struct SocialApp: Decodable, Hashable {
    let id, name, imageUrl, tagline: String
}
