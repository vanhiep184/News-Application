//
//  NewsServiceAPI.swift
//  News App
//
//  Created by I Am Focused on 12/2/19.
//  Copyright © 2019 LVHhcmus. All rights reserved.
//

import Foundation
import CodableAlamofire

// News Response
struct NewsResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [New]

//
//    enum CodingKeys: String, CodingKey {
//        case status
//        case totalResults
//        case articlesList
//    }
//
//    enum ArticlesList: String, CodingKey {
//        case sourceInfo
//        case author, title, description, url, urlToImage, publishedAt, content
//    }
//    enum SourceInfo: String, CodingKey {
//        case id, name
//    }



}
// New Structure
struct New: Codable {
    let source: Source
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?

}
//Source of New
struct Source: Codable {
    let id: String?
    let name: String?
}




class NewServiceAPI {
    public static let shared = NewServiceAPI()

    private init() {

    }
    private let urlSession = URLSession.shared
    private let baseURL = URL(string: "https://newsapi.org/v2/top-headlines")!
    private let APIKey = "0e77d9600fa342989f8eb644e6f4450e"

    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
//        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()



    public enum APIServiceError: Error {
        case APIError
        case invalidResponse
        case invalidEndpoint
        case noData
        case decodeError
    }


    //Fetching data form server on country = us
    private func fetchNews<T: Decodable>(url: URL, completion: @escaping (Result<T, APIServiceError>) -> Void) {


        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion(.failure(.invalidEndpoint))
            return

        }
        let queryItems = [URLQueryItem(name: "country", value: "us"), URLQueryItem(name: "apiKey", value: APIKey)]
        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        print(url)
        urlSession.dataTask(with: url) {
            (result) in
            switch (result) {
            case .success(let (response, data)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    completion(.failure(.invalidResponse))
                    return
                }
                do {
                   let values = try self.jsonDecoder.decode(T.self, from: data)
                    completion(.success(values))
                } catch let jsonError {
                    print(jsonError)
                    completion(.failure(.decodeError))
                }


            case .failure(_):
                completion(.failure(.APIError))
            }
        }.resume()

    }


    public func fetchNewsbyCountry(countryName: String, result: @escaping (Result<NewsResponse, APIServiceError>) -> Void) {

        let newURL = baseURL

        fetchNews(url: newURL, completion: result)
    }

}



