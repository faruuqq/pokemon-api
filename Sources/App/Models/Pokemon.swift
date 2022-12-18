//
//  File.swift
//  
//
//  Created by Muhammad Faruuq Qayyum on 18/12/22.
//

import Vapor
import Fluent

final class Pokemon: Model {
    static let schema = "pokemon"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "created_at")
    var createdAt: Date?
    
    @Field(key: "updated_at")
    var updatedAt: Date?
    
    init() { }
    
    init(id: UUID? = nil, name: String, createdAt: Date? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension Pokemon: Content { }

extension Pokemon {
    static var createdAtKey: WritableKeyPath<Pokemon, Date?> {
        return \.createdAt
    }
    
    static var updatedAtKey: WritableKeyPath<Pokemon, Date?> {
        return \.updatedAt
    }
}
