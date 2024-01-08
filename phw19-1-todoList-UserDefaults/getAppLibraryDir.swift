//
//  func.swift
//  phw19-1-todoList-UserDefaults
//
//  Created by jasonhung on 2024/1/8.
//

import Foundation

func getAppLibraryDir(){
    if let appLibraryDir = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first {
                
          // 拼接 Preferences 子目錄
          let preferencesDir = appLibraryDir.appendingPathComponent("Preferences")
                
          // 檢查 Preferences 目錄是否存在
          if FileManager.default.fileExists(atPath: preferencesDir.path) {
                print("UserDefaults 存儲位置：\(preferencesDir.path)")
          } else {
                print("UserDefaults 存儲位置未找到")
          }
     } else {
        print("無法獲取應用程序沙盒目錄")
     }
}
