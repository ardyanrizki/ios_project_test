//
//  NewsArticle.swift
//  iOS Project Test
//
//  Created by Ardyan on 22/10/21.
//

import Foundation

class NewsArticleAPI: NSObject, URLSessionDownloadDelegate {
    
    static let shared = NewsArticleAPI()
    
    var progressCount: Float?
    
    struct Constants {
        static let mostViewedURL = URL(string:
        "https://api.nytimes.com/svc/mostpopular/v2/viewed/1.json?api-key=Lh8YGSZGBs8C5yTl4cOt2MbLlA59rGAl")
    }
    
    private override init() {}
    
    public func getMostViewed(completion: @escaping (Result<[Article], Error>) -> Void ) {
        guard let url = Constants.mostViewedURL else {
            return
        }
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        
//        session.downloadTask(with: url).resume()
        
        let task = session.dataTask(with: url) { data, mid, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(News.self, from: data)

                    completion(.success(decoded.results))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }

        task.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        progressCount = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
    }
}
