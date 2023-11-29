//
//  ModelController.swift
//  PokemonTestingDemo
//
//  Created by Ryan Plitt on 11/28/23.
//

import Foundation

struct Pokemon: Decodable {
    var imageURL: String
    var name: String
    
    enum CodingKeys: CodingKey {
        case sprites
        case name
    }
    
    enum SpriteCodingKeys: CodingKey {
        case other
    }
    
    enum OtherCodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
    
    enum OfficialArtworkCodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        let sprite = try container.nestedContainer(keyedBy: SpriteCodingKeys.self, forKey: .sprites)
        let otherContainer = try sprite.nestedContainer(keyedBy: OtherCodingKeys.self, forKey: .other)
        
        let officialArtwork = try otherContainer.nestedContainer(keyedBy: OfficialArtworkCodingKeys.self, forKey: .officialArtwork)
        
        let artwork = try officialArtwork.decode(String.self, forKey: .frontDefault)
        imageURL = artwork
    }
}

class ModelController {
    func fetchPokemon(number: Int) async -> Pokemon? {
        do {
            let (data, _) = try await URLSession.shared.data(for: URLRequest(url: URL(string: "https://pokeapi.co/api/v2/pokemon/\(number)")!))
            let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
            return pokemon
        } catch {
            print("Uh oh")
        }
        return nil
    }
}
