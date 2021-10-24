//
//  NewsArticle.swift
//  iOS Project Test
//
//  Created by Ardyan on 22/10/21.
//

import Foundation

final class NewsArticleAPI {
    static let shared = NewsArticleAPI()
    
    struct Constants {
        static let mostViewedURL = URL(string:
        "https://api.nytimes.com/svc/mostpopular/v2/viewed/1.json?api-key=Lh8YGSZGBs8C5yTl4cOt2MbLlA59rGAl")
    }
    
    private init() {}
    
    public func getMostViewed(completion: @escaping (Result<[Article], Error>) -> Void ) {
        guard let url = Constants.mostViewedURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(News.self, from: data)
                    
                    print("Articles: \(decoded)")
                    completion(.success(decoded.results))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}
