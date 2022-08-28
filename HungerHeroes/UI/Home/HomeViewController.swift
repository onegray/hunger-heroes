//
//  HomeViewController.swift
//  HungerHeroes
//
//  Created by onegray on 28.08.22.
//

import UIKit
import SwiftUI

class HomeViewController: UIHostingController<HomeView> {
    
    let environment: Environment
    let presenter: HomePresenterProtocol
    var viewModel: HomeViewModel { self.presenter.viewModel }

    init(environment: Environment) {
        self.environment = environment
        self.presenter = environment.homePresenter()
        super.init(rootView: HomeView(viewModel: self.presenter.viewModel))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
