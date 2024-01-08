//
//  bbb.swift
//  phw19-1-todoList-UserDefaults
//
//  Created by jasonhung on 2024/1/8.
//

import Foundation

func printUserDefaults(){
    //All values:
    print("\nAll values:")
    print(UserDefaults.standard.dictionaryRepresentation().values)
    //All keys:
    print("\nAll keys:")
    print(UserDefaults.standard.dictionaryRepresentation().keys)
    //All keys and values:
    print("\nAll keys and values:")
    print(UserDefaults.standard.dictionaryRepresentation())
}


