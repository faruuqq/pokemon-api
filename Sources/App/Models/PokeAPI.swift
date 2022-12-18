//
//  File.swift
//  
//
//  Created by Muhammad Faruuq Qayyum on 18/12/22.
//

import Vapor

public final class PokeAPI {
    let client: Client
    let cache: Cache
    
    public init(client: Client, cache: Cache) {
        self.client = client
        self.cache = cache
    }
    
    public func verifyName(_ name: String) async throws -> Bool {
        let key = name.lowercased()
        if let exists = try await cache.get(key, as: Bool.self) {
            print("--faruuq: exists is", exists)
            return exists
        }
        
        let newPokemon = try await fetchPokemon(named: name)
        switch newPokemon.status.code {
        case 200..<300:
            try await cache.set(key, to: true)
            print("--faruuq: cache is true")
            return true
        case 404:
            try await cache.set(key, to: false)
            print("--faruuq: cache is false")
            return false
        default:
            throw Abort(.internalServerError, reason: "Unexpected PokeAPI response: \(newPokemon.status)")
        }
        
    }
    
    public func fetchPokemon(named name: String) async throws -> ClientResponse {
        return try await client.get("https://pokeapi.co/api/v2/pokemon/\(name)")
    }
}

extension PokeAPI {
    public static func makeService(for req: Request) -> PokeAPI {
        PokeAPI(client: req.client, cache: req.cache)
    }
}
