//
//  FakeResponseData.swift
//  classQuoteTests
//
//  Created by vincent  on 17/10/2018.
//  Copyright © 2018 Loret Vincent. All rights reserved.
//

import Foundation

class FakeResponseData {
    let responseOK = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    let responseKO = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
    
    class QuoteError: Error {}
    let error = QuoteError()
    
    var quoteCorrectData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Quote", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    let quoteIncorrectData = "Erreur".data(using: .utf8)!
    
    let imageData = "image".data(using: .utf8)!
    
}
