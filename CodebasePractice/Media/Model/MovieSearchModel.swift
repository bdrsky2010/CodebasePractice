//
//  MovieSearchModel.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/11/24.
//

import Foundation

struct TMDBMovieSearch: Decodable {
    let page: Int
    var results: [MovieSearch]
    let total_pages: Int
    let total_results: Int
}

struct MovieSearch: Decodable {
    let id: Int
    let backdrop_path: String?
    let poster_path: String?
    let genre_ids: [Int]
    let original_title: String
    let title: String
    let overview: String
    let release_date: String
    let vote_average: Double
}
