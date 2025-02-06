// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let filmSearchByID = try? JSONDecoder().decode(FilmSearchByID.self, from: jsonData)

import Foundation

// MARK: - FilmSearchByID
struct FilmSearchByID: Decodable {
    let kinopoiskID: Int?
    let kinopoiskHDID, imdbID, nameRu: String?
    let nameEn: String?
    let nameOriginal: String?
    let posterURL, posterURLPreview: String?
    let coverURL: String?
    let logoURL: String?
    let reviewsCount, ratingGoodReview, ratingGoodReviewVoteCount: Int?
    let ratingKinopoisk: Double?
    let ratingKinopoiskVoteCount: Int?
    let ratingImdb: Double?
    let ratingImdbVoteCount: Int?
    let ratingFilmCritics: Double?
    let ratingFilmCriticsVoteCount: Int?
    let ratingAwait: String?
    let ratingAwaitCount, ratingRFCritics, ratingRFCriticsVoteCount: Int?
    let webURL: String?
    let year, filmLength: Int?
    let slogan: String?
    let description, shortDescription: String?
    let editorAnnotation: String?
    let isTicketsAvailable: Bool?
    let productionStatus: String?
    let type, ratingMPAA, ratingAgeLimits: String?
    let countriess: [Countrys]?
    let genress: [Genres]?
    let startYear, endYear: String?
    let serial, shortFilm, completed, hasImax: Bool?
    let has3D: Bool?
    let lastSync: String?

    enum CodingKeys: String, CodingKey {
        case kinopoiskID = "kinopoiskId"
        case kinopoiskHDID
        case imdbID
        case nameRu, nameEn, nameOriginal
        case posterURL = "posterUrl"
        case posterURLPreview
        case coverURL
        case logoURL
        case reviewsCount, ratingGoodReview, ratingGoodReviewVoteCount, ratingKinopoisk, ratingKinopoiskVoteCount, ratingImdb, ratingImdbVoteCount, ratingFilmCritics, ratingFilmCriticsVoteCount, ratingAwait, ratingAwaitCount
        case ratingRFCritics
        case ratingRFCriticsVoteCount
        case webURL
        case year, filmLength, slogan, description, shortDescription, editorAnnotation, isTicketsAvailable, productionStatus, type
        case ratingMPAA
        case ratingAgeLimits, countriess, genress, startYear, endYear, serial, shortFilm, completed, hasImax, has3D, lastSync
    }
}

// MARK: - Country
struct Countrys: Decodable {
    let country: String?
}

// MARK: - Genre
struct Genres: Decodable {
    let genre: String?
}







