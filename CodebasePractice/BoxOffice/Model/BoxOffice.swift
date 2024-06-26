//
//  BoxOffice.swift
//  CodebasePractice
//
//  Created by Minjae Kim on 6/26/24.
//

import Foundation

struct DailyBoxOffice: Decodable {
    let boxOfficeResult: BoxOfficeResult
}

struct BoxOfficeResult: Decodable {
    let dailyBoxOfficeList: [BoxOffice]
}

struct BoxOffice: Decodable {
    let rank: String
    let movieNm: String
    let openDt: String
}
