//
//  TodoModel.swift
//  Fetch Data From An API
//
//  Created by Akshay Yendhe on 07/02/23.
//

import Foundation

struct TodoModel : Codable{
    let todos : [Todo]
    let total : Int
    let skip : Int
    let limit : Int
}

struct Todo : Codable {
    let id : Int
    let todo : String
    let completed : Bool
    let userId : Int
}
