//
//  File.swift
//  
//
//  Created by Muhammad Faruuq Qayyum on 18/12/22.
//

import Fluent

struct CreatePokemon: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Pokemon.schema)
            .id()
            .field("name", .string, .required)
            .field("created_at", .date)
            .field("updated_at", .date)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Pokemon.schema)
            .delete()
    }
}
