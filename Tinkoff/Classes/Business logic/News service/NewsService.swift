//
//  NewsService.swift
//  Tinkoff
//
//  Created by Timofey on 3/20/17.
//  Copyright © 2017 Timofey. All rights reserved.
//

import Foundation
import RxSwift
import DAO

class NewsService: BasicService<NewsTarget> {
  
  let dao: AnyDAO<NewsItem>
  
  init(scheduler: SchedulerType, dao: AnyDAO<NewsItem>) {
    self.dao = dao
    super.init(scheduler: scheduler)
  }
  
  func getNewsFromAPI() -> Observable<NewsResponse> {
    return
      provider
        .request(.tinkoff)
        .timeout(defaultTimeout, scheduler: workScheduler)
        .observeOn(workScheduler)
        .mapResponse(NewsResponse.self)
        .observeOn(MainScheduler.instance)
        //TODO: .persist()
        .do(
          onNext: { [unowned self] response in
            try self.dao.persist(entities: response.newsList)
        })
  }
  
  //TODO: separate service
  func getDetailedNewsItem(for item: NewsItem) -> Observable<DetailedNewsResponse> {
    return
      provider
        .request(.detailedItem(for: item))
        .timeout(defaultTimeout, scheduler: workScheduler)
        .mapResponse(DetailedNewsResponse.self)
        .observeOn(MainScheduler.instance)
  }
  
  //TODO: Implement business logic for cached objects retriaval
  func getNewsFromDAO() -> Observable<NewsResponse> {
    return
      Observable
        .just()
        .observeOn(MainScheduler.instance)
        .map{ [unowned self] in
          //TODO: DAO<NewsResponse>?
          let news = self.dao.getAll()
          return NewsResponse(newsList: news)
        }
    
  }
  
}
