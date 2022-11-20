//
//  HomeViewModel.swift
//  HungerHeroes
//
//  Created by onegray on 27.08.22.
//

import Foundation

class HomeViewModel: ObservableObject {

    @Published var loginStatus: LoginStatus = .notSigned(error: nil)

    @Published var username: String = "User42"
    @Published var password: String = "password"
    @Published var signInButtonEnabled: Bool = false
}


extension HomeViewModel {

    enum LoginStatus: Equatable {
        case notSigned(error: String?)
        case loading
        case signed
    }
}
