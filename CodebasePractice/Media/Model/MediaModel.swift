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
    let original_title: String
    let genre_ids: [Int]
    let release_date: String
    let vote_average: Double
    
    enum CodingKeys: CodingKey {
        case backdrop_path
        case id
        case overview
        case poster_path
        case title
        case original_title
        case genre_ids
        case release_date
        case vote_average
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.backdrop_path = try container.decodeIfPresent(String.self, forKey: .backdrop_path) ?? ""
        self.id = try container.decode(Int.self, forKey: .id)
        self.overview = try container.decode(String.self, forKey: .overview)
        self.poster_path = try container.decode(String.self, forKey: .poster_path)
        self.title = try container.decode(String.self, forKey: .title)
        self.original_title = try container.decode(String.self, forKey: .original_title)
        self.genre_ids = try container.decode([Int].self, forKey: .genre_ids)
        self.release_date = try container.decode(String.self, forKey: .release_date)
        self.vote_average = try container.decode(Double.self, forKey: .vote_average)
    }
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

struct TMDBMovieSearch: Decodable {
    let page: Int
    var results: [TMDBMovie]
    let total_pages: Int
    let total_results: Int
}


// MARK: TMDB Movie Poster Model
struct TMDBMoviePoster: Decodable {
    let backdrops: [FilePath]
}

struct FilePath: Decodable {
    let filePath: String
    
    enum CodingKeys: String, CodingKey {
        case filePath = "file_path"
    }
}
