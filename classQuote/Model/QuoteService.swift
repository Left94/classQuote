//
//  QuoteService.swift
//  classQuote
//
//  Created by vincent  on 17/10/2018.
//  Copyright © 2018 Loret Vincent. All rights reserved.
//

import Foundation

class QuoteService {
    static var shared = QuoteService()
    private init() {}

    private static let quoteUrl = URL(string: "http://api.forismatic.com/api/1.0/")!
    private static let pictureUrl = URL(string: "https://source.unsplash.com/random")!
    
    private var task :URLSessionDataTask?
    
    func getQuote(callback: @escaping (Bool, Quote?) -> Void) {
        var request = URLRequest(url: QuoteService.quoteUrl)
        request.httpMethod = "POST"
        
        let body = "method=getQuote&format=json&lang=en"
        request.httpBody = body.data(using: .utf8)
        let session = URLSession(configuration: .default)
        
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
                guard let responseJSON = try? JSONDecoder().decode([String: String].self, from: data),
                    let text = responseJSON["quoteText"],
                    let author = responseJSON["quoteAuthor"] else {
                    callback(false, nil)
                    return
                }
                self.getImage(completionHandler: { (data) in
                        guard let data = data else {
                            callback(false, nil)
                            return
                        }
                let quote = Quote(text: text,author: author, imageData: data)
                callback(true, quote)
                            })
            }
            
        }
        
        task?.resume()
    }
    
    private func getImage(completionHandler: @escaping (Data?) -> Void) {
        let session = URLSession(configuration: .default)
        
        task?.cancel()
        task = session.dataTask(with: QuoteService.pictureUrl) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completionHandler(nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completionHandler(nil)
                    return
                }
                    completionHandler(data)
            }
        }
        task?.resume()        
    }
}
