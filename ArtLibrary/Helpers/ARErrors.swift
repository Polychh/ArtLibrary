//
//  ARErrors.swift
//  ArtLibrary
//
//  Created by Polina on 13.02.2024.
//

import Foundation
enum ARErrors: Error, LocalizedError{
    case invalidURL
    case invalidResponse
    case invalidData
    case invalidImage
    case unknow(Error)
    
    var errorDescription: String?{
        switch self{
        case .invalidURL:
            return "Wrong URL"
        case .invalidResponse:
            return  "Wrong Response"
        case .invalidData:
            return "Can not to decode Data"
        case.invalidImage:
            return "Can not download Image"
        case .unknow(let error):
            return error.localizedDescription
        }
    }
}
