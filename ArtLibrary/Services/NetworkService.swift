//
//  NetworkService.swift
//  ArtLibrary
//
//  Created by Polina on 13.02.2024.
//

import Foundation
protocol NetworkServiceprotocol{
    func request() async throws -> [Artist]
}

final class NetworkService: NetworkServiceprotocol{
    func request() async throws -> [Artist] {
        guard let url = URL(string: "https://file.notion.so/f/f/b8bbfa88-ab7c-464e-8c0e-1c109af93066/8c0c0258-c23a-4229-ae76-b515867cc1d8/artists.json?id=65f3a8fb-a15e-48f4-a7ed-f75be1b2f4fb&table=block&spaceId=b8bbfa88-ab7c-464e-8c0e-1c109af93066&expirationTimestamp=1708336800000&signature=L5omQtXDQCVe0-NPNBapFApCukNUc9TuWiH7_iOSSwY&downloadName=artists.json")
        else{ throw ARErrors.invalidURL}
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw
            ARErrors.invalidResponse}
        
        do{
            let artistsInfo = try JSONDecoder().decode(ArtistArray.self, from: data)
            return artistsInfo.artists
        }catch{
            throw ARErrors.invalidData
        }
    }
}
