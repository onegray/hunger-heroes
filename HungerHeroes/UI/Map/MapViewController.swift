//
// Created by onegray on 28.08.22.
//

import UIKit
import Combine

class MapViewController: UIViewController {

    let environment: Environment
    let presenter: MapPresenterProtocol
    var viewModel: MapViewModel { self.presenter.viewModel }
    var disposeBag = Set<AnyCancellable>()

    var mapView: UIImageView!
    var fowLayer: CALayer!
    var fowMaskLayer: CALayer!

    init(_ environment: Environment, gameId: String?) {
        self.environment = environment
        self.presenter = environment.mapPresenter()
        super.init(nibName: nil, bundle: nil)

        if let gameId = gameId {
            self.presenter.loadGame(gameId: gameId)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.fowMaskLayer = CALayer()
        self.fowMaskLayer.contentsGravity = .resize

        self.fowLayer = CALayer()
        self.fowLayer.mask = self.fowMaskLayer

        self.mapView = UIImageView(frame: .zero)
        self.mapView.layer.addSublayer(self.fowLayer)

        let scrollView = UIScrollView(frame: .zero)
        scrollView.backgroundColor = .white
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.25
        scrollView.maximumZoomScale = 4.0
        scrollView.addSubview(self.mapView)
        self.view = scrollView
    }

    override func viewDidLoad() {

        self.viewModel.$mapImage
                .sink { (img: CGImage?) in
                    self.mapView.image = (img != nil ? UIImage(cgImage: img!) : nil)
                }
                .store(in: &self.disposeBag)

        self.viewModel.$mapSize
                .sink { (size: CGSize) in
                    (self.view as! UIScrollView).contentSize = size
                    self.mapView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                }
                .store(in: &self.disposeBag)
    }
}

extension MapViewController: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.mapView
    }
}
