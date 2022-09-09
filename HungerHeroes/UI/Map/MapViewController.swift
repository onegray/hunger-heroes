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

    var scrollView: UIScrollView { self.view as! UIScrollView }
    var mapView: UIView!
    var fowView: UIView!
    var fowMaskLayer: CALayer!
    var topObjectsView: UIView!


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

        self.fowView = UIView(frame: .zero)
        self.fowView.layer.mask = self.fowMaskLayer

        self.mapView = UIView(frame: .zero)
        self.mapView.addSubview(self.fowView)

        self.topObjectsView = UIView(frame: .zero)
        self.topObjectsView.backgroundColor = .clear

        let scrollView = UIScrollView(frame: .zero)
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.25
        scrollView.maximumZoomScale = 4.0
        scrollView.addSubview(self.mapView)
        scrollView.addSubview(self.topObjectsView)
        self.view = scrollView
    }

    override func viewDidLoad() {

        let backImageTemplate = UIImage(named: "map-back32")!
        self.view.backgroundColor = UIColor(patternImage: backImageTemplate)

        let fowImageTemplate = UIImage(named: "map-fow96")!
        self.fowView.backgroundColor = UIColor(patternImage: fowImageTemplate)

        self.viewModel.$mapImage
                .sink { (img: CGImage?) in
                    self.mapView.layer.contents = img
                }
                .store(in: &self.disposeBag)

        self.viewModel.$mapSize
                .sink { (size: CGSize) in
                    (self.view as! UIScrollView).contentSize = size
                    self.mapView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                    self.fowView.frame = self.mapView.bounds
                    self.fowMaskLayer.frame = self.mapView.bounds
                    self.topObjectsView.frame = self.mapView.frame
                }
                .store(in: &self.disposeBag)

        self.viewModel.$fowMaskImage
                .sink { (img: CGImage?) in
                    self.fowMaskLayer.contents = img
                }
                .store(in: &self.disposeBag)

        self.viewModel.$heroes
                .sink { (heroes: [HeroViewModel]) in
                    _ = self.topObjectsView.subviews.map { $0.removeFromSuperview() }
                    let imgCfg = UIImage.SymbolConfiguration(pointSize: 22, weight: .semibold)
                    let heroImg = UIImage(systemName: "flag", withConfiguration: imgCfg)?
                            .withTintColor(.orange, renderingMode: .alwaysOriginal)
                    for hero in heroes {
                        let heroView = MapObjectView(image: heroImg)
                        heroView.location = self.mapPoint(hero.location)
                        heroView.mapZoom = self.scrollView.zoomScale
                        self.topObjectsView.addSubview(heroView)
                    }
                }
                .store(in: &self.disposeBag)
    }

    func mapPoint(_ point: Point) -> Point {
        return Point(x: point.x, y: Int(self.mapView.bounds.size.height) - point.y)
    }
}

extension MapViewController: UIScrollViewDelegate {

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.mapView
    }

    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        for obj in self.topObjectsView.subviews as! [MapObjectView] {
            obj.mapZoom = scrollView.zoomScale
        }
    }
}
