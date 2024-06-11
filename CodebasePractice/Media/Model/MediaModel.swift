//
//  MediaModel.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/10/24.
//

import Foundation

// MARK: TMDB Movie Trend time_window Type => 'day' OR 'week'
enum TimeWindowType {
    case day
    case week
    
    var string: String {
        return String(describing: self)
    }
}

// MARK: TMDB Movie Trend Model
struct TMDBMovieTrend: Decodable {
    let results: [TMDBMovie]
}

struct TMDBMovie: Decodable {
    let backdrop_path: String
    let id: Int
    let overview: String
    let poster_path: String
    let title: String
    let genre_ids: [Int]
    let release_date: String
    let vote_average: Double
}

// MARK: TMDB Movie Genre Model
struct TMDBMovieGenre: Decodable {
    let genres: [Genre]
}

struct Genre: Decodable {
    let id: Int
    let name: String
}

// MARK: TMDB Movie Credit Model
struct TMDBMovieCredit: Decodable {
    let cast: [Cast]
}

struct Cast: Decodable {
    let known_for_department: String // Acting 키워드만 필터링
    let name: String
    let profile_path: String?
    let character: String? // 역할
}
