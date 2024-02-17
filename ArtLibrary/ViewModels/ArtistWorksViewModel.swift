//
//  ArtistWorksViewModel.swift
//  ArtLibrary
//
//  Created by Polina on 13.02.2024.
//

import Foundation
import Combine

final class ArtistWorksViewModel{
    @Published var works: [Work]
    
    init(works: [Work]) {
        self.works = works
    }
}
