//
//  Todo.swift
//  Todo
//
//  Created by jasonhung on 2024/1/7.
//

import Foundation

let todoKey = "Todos"

struct Todo: Codable, Equatable {
    //var date: Date          // 任務的日期
    //var createdBy: String   // 任務的創建者
    //var assignedTo: String  // 任務指派給的人
    var title: String       // 任務的標題
    var note: String?       // 任務的附註（可選）
    var isCompleted: Bool
    
    //var status: String      // 任務的狀態，例如 "待辦"、"進行中"、"已完成"
    //var recurrence: String?  // 任務的重複性，例如每天、每週等（可選）
    //var tags: [String]?     // 任務的標籤，用於分類和尋找特定任務（可選）
    
    static func loadTodos() -> [Todo]? {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.data(forKey: todoKey) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode([Todo].self, from: data)
    }
    
    static func saveTodos(_ todos: [Todo]) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(todos) else { return }
        UserDefaults.standard.set(data, forKey: todoKey)
    }
    
    static func == (lhs: Todo, rhs: Todo) -> Bool {
        return lhs.title == rhs.title &&
        lhs.note == rhs.note &&
        lhs.isCompleted == rhs.isCompleted
    }
    
    static func removeTodos(){
        UserDefaults.standard.removeObject(forKey: todoKey)
    }
}

