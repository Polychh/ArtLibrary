//
//  MainViewModel.swift
//  ArtLibrary
//
//  Created by Polina on 12.02.2024.
//

import Foundation
import Combine

final class MainViewModel{
    
    @Published var artistArray: [Artist] = []
    @Published var filterArtistArray: [Artist] = []
    
    @Published var newArtist: [String] = []
    @Published var addNewArtist: Artist = Artist(name: "", bio: "", image: "", works: [Work(title: "", image: "", info: "")])
    
    private var cancellables = Set<AnyCancellable>()
    
    private let network: NetworkServiceprotocol
    init(network: NetworkServiceprotocol){
        self.network = network
        fetchArtistsData()
        observe()
    }
    
    private func fetchArtistsData(){
        Task{ @MainActor in
            do{
                artistArray = try await network.request()
            } catch{
                loadJson(filename: "Artists")
                print(error.localizedDescription)
            }
        }
    }
    
    private func observe(){
        $newArtist
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { artist in
                    self.addNewArtist = Artist(name: artist[0], bio: artist[1], image: artist[2], works: [Work(title: artist[3], image: artist[4], info: artist[5])])
            }
            .store(in: &cancellables)
        
    }
    
   private func loadJson(filename fileName: String) {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json"){
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ArtistArray.self, from: data)
                artistArray = jsonData.artists
            } catch {
                print("error:\(error)")
            }
        }
    }
}

