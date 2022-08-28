//
// Created by onegray on 28.08.22.
//

import UIKit

class MapViewController: UIViewController {

    let environment: Environment
    let presenter: MapPresenterProtocol
    var viewModel: MapViewModel { self.presenter.viewModel }

    init(_ environment: Environment) {
        self.environment = environment
        self.presenter = environment.mapPresenter()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func loadView() {
        self.view = UIScrollView(frame: .zero)
    }

    override func viewDidLoad() {
        self.setupToolbar()
    }

    func setupToolbar() {

    }
}

