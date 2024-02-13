//
//  Artists.swift
//  ArtLibrary
//
//  Created by Polina on 12.02.2024.
//

import Foundation


// MARK: - Artists
struct ArtistArray: Decodable {
    let artists: [Artist]
}

// MARK: - Artist
struct Artist: Decodable {
    let name, bio, image: String
    let works: [Work]
}

// MARK: - Work
struct Work: Decodable {
    let title, image, info: String
}
