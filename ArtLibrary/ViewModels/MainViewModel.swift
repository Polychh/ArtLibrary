//
//  MainViewModel.swift
//  ArtLibrary
//
//  Created by Polina on 12.02.2024.
//

import Foundation

final class MainViewModel{
    
    @Published var artistArray: [Artist] = []
    @Published var filterArtistArray: [Artist] = []
    
    private let network: NetworkServiceprotocol
    init(network: NetworkServiceprotocol){
        self.network = network
        fetchArtistsData()
    }
    
    private func fetchArtistsData(){
        Task{ @MainActor in
            do{
                artistArray = try await network.request()
            } catch{
                print(error.localizedDescription)
            }
        }
    }
    
//   private func loadJson(filename fileName: String) {
//        if let url = Bundle.main.url(forResource: fileName, withExtension: "json"){
//            do {
//                let data = try Data(contentsOf: url)
//                let decoder = JSONDecoder()
//                let jsonData = try decoder.decode(ArtistArray.self, from: data)
//                artistArray = jsonData.artists
//            } catch {
//                print("error:\(error)")
//            }
//        }
//    }
}

