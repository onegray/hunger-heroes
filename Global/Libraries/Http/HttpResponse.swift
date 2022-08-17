//
//  HttpResponse.swift
//  HungerHeroes
//
//  Created by onegray on 15.08.22.
//

import Foundation

class HttpResponse {

    var status: ResponseStatus
    var code: Int

    required init(data: Data?, code: Int) {
        self.status = .success
        self.code = code
    }

    required init(error: Error, code: Int) {
        self.status = .failure(error)
        self.code = code
    }
}


extension HttpResponse {

    enum ResponseStatus {
        case success
        case failure(Error)
    }
}
