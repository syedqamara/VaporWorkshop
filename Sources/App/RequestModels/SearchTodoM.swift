//
//  SearchTodoM.swift
//  App
//
//  Created by Syed Qamar Abbas on 04/10/2019.
//

import Vapor

final class SearchRequestM: Content {
    var search_text: String?
    
    init(search_text: String?) {
        self.search_text = search_text
    }
}


final class SearchResponseM: Content {
    var message: String = ""
    var status_code: Int = 200
    var data: [Todo] = []
}
