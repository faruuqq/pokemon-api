//
//  File.swift
//  
//
//  Created by Muhammad Faruuq Qayyum on 18/12/22.
//

import Vapor
import FluentSQL

final class PokemonController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        routes.get("pokemon", use: index(_:))
        routes.post("pokemon", "create", use: create(_:))
    }
    
    func index(_ req: Request) async throws -> [Pokemon] {
        try await Pokemon.query(on: req.db).all()
    }
    
    func create(_ req: Request) async throws -> Pokemon {
        let newPokemon = try req.content.decode(Pokemon.self)
        
        let pokeApi = PokeAPI.makeService(for: req)
        let nameVerified = try await pokeApi.verifyName(newPokemon.name)
        guard nameVerified else {
            throw Abort(.badRequest, reason: "Invalid Pokemon \(newPokemon.name).")
        }
        if let _ = try await Pokemon.query(on: req.db).all().first(where: { $0.name == newPokemon.name }) {
            throw Abort(.badRequest, reason: "You already caught \(newPokemon.name).")
        }
        
        try await newPokemon.save(on: req.db)
        return newPokemon
    }
    
    
}
