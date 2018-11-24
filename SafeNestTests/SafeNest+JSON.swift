//
//  SafeNest+JSON.swift
//  SafeNestTests
//
//  Created by Hai Pham on 11/20/18.
//  Copyright © 2018 swiften. All rights reserved.
//

import XCTest
@testable import SafeNest

public final class CustomJSONEncoder: JSONEncoder {}
public final class CustomJSONDecoder: JSONDecoder {}

public final class JSONTests: XCTestCase {
  public struct Data: Encodable & Decodable {
    public let by: String
    public let descendants: Int
    public let id: Int
    public let kids: [Int]
    public let score: Int
    public let time: Double
    public let title: String
    public let type: String
    public let url: String
  }
  
  public func test_settingJSONObject() throws {
    /// Setup
    let json: [String : Any] = [
      "by" : "dhouston",
      "descendants" : 71,
      "id" : 8863,
      "kids" : [
        9224,
        8952,
        8917,
        8884,
        8887,
        8869,
        8940,
        8908,
        8958,
        9005,
        8873,
        9671,
        9067,
        9055,
        8865,
        8881,
        8872,
        8955,
        10403,
        8903,
        8928,
        9125,
        8998,
        8901,
        8902,
        8907,
        8894,
        8870,
        8878,
        8980,
        8934,
        8943,
        8876
      ],
      "score" : 104,
      "time" : 1175714200,
      "title" : "My YC app: Dropbox - Throw away your USB drive",
      "type" : "story",
      "url" : "http://www.getdropbox.com/u/2/screencast.html"
    ]
    
    let expect = expectation(description: "Should have completed")
    
    let task = URLSession.shared.dataTask(with:
      URL(string: "https://hacker-news.firebaseio.com/v0/item/8863.json?print=pretty")!
    ) {(data, _, err) in
      /// Then
      var nest = try! SafeNest.builder()
        .with(jsonEncoder: CustomJSONEncoder())
        .with(jsonDecoder: CustomJSONDecoder())
        .with(json: data!)
        .build()
      
      let dataDecoded = nest.decode(at: "", ofType: Data.self).value!
      nest = try! nest.encoding(value: dataDecoded)
      nest = try! nest.updating(at: "kids.0", value: 9999)
      nest = try! nest.updating(at: "descendants", value: 101)
      XCTAssertEqual(nest.value(at: "kids.0").value as? Int, 9999)
      XCTAssertEqual(nest.value(at: "descendants").value as? Int, 101)
      XCTAssertEqual(dataDecoded.by, json["by"] as? String)
      XCTAssertEqual(dataDecoded.kids, json["kids"] as? [Int])
      expect.fulfill()
    }
    
    /// When
    task.resume()
    waitForExpectations(timeout: 100, handler: nil)
  }
}
