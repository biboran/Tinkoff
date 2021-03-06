//
//  NewsResponse.swift
//  Tinkoff
//
//  Created by Timofey on 3/20/17.
//  Copyright © 2017 Timofey. All rights reserved.
//

import Foundation
import ObjectMapper

struct NewsResponse {
  
  var newsList: [NewsItem]!
  
}

extension NewsResponse: Mappable {
  
  init?(map: Map) { }
  
  mutating func mapping(map: Map) {
    newsList <- map["payload"]
  }
  
}
