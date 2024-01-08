//
//  Lover.swift
//  Lover
//
//  Created by Peter Pan on 2021/8/23.
//

import Foundation

struct Todo: Codable {
    var name:String
    var star: String
    var innerBeauty: Bool
    var weight: Double
    
    static func loadLovers() -> [Todo]? {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.data(forKey: "lovers") else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode([Todo].self, from: data)
    }
    
    static func saveLovers(_ lovers: [Todo]) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(lovers) else { return }
        UserDefaults.standard.set(data, forKey: "lovers")
    }
}
