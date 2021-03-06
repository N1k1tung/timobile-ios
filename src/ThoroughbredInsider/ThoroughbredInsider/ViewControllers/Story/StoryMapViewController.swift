//
//  StoryMapViewController.swift
//  ThoroughbredInsider
//
//  Created by TCCODER on 11/1/17.
//  Copyright © 2017 Topcoder. All rights reserved.
//

import UIKit
import MapKit
import RxCocoa
import RxSwift
import RealmSwift
import RxRealm

/**
 * Story map screen
 *
 * - author: TCCODER
 * - version: 1.0
 */
class StoryMapViewController: UIViewController {
    
    /// outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var storyView: StoryView!
    @IBOutlet weak var countLabel: UILabel!
    
    /// search query
    var query = Variable<String>("")
    /// viewmodel
    var vm = Variable<[Story]>([])
    /// selected
    private var selected: Story?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupVM()
        loadData(from: MockDataSource.getStories())
    }
    
    /// configure vm
    ///
    /// - Parameter filter: current filter
    private func setupVM() {
        Story.fetch()
            .bind(to: vm)
            .disposed(by: rx.bag)
        vm.asObservable()
            .subscribe(onNext: { [weak self] value in
                self?.mapView.removeAnnotations(self?.mapView.annotations ?? [])
                self?.mapView.addAnnotations(value.map { StoryAnnotation(story: $0) })
                self?.countLabel.text = "Displaying \(value.count) of \(value.count) stories in these area"
            }).disposed(by: rx.bag)
    }

    /// story tile tap handler
    ///
    /// - Parameter sender: the button
    @IBAction func storyTapped(_ sender: Any) {
        guard let vc = create(viewController: StoryDetailsViewController.self, storyboard: .details) else { return }
        vc.story = selected
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// configure story view
    ///
    /// - Parameter value: selected story
    fileprivate func configureSelected(value: Story) {
        selected = value
        storyView.storyImage.load(url: value.image)
        storyView.titleLabel.text = value.name
        storyView.racetrackLabel.text = value.race?.name
        storyView.shortDescriptionLabel.text = value.content
        storyView.shortDescriptionLabel.setLineHeight(16)
        storyView.chaptersLabel.text = "\(value.chapters) \("chapters".localized)"
        storyView.cardsLabel.text = "\(value.cards) \("cards".localized)"
        storyView.milesLabel.text = "\(value.miles) \("miles".localized)"
    }
    
}

// MARK: - MKMapViewDelegate
extension StoryMapViewController: MKMapViewDelegate {
    
    /// reuse identifier
    static let kAnnotationView = "kAnnotationView"
    
    /// configure annotation view
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? StoryAnnotation else { return nil }
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: StoryMapViewController.kAnnotationView) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: StoryMapViewController.kAnnotationView)
        view.image = mapView.selectedAnnotations.contains { $0.coordinate.longitude == annotation.coordinate.longitude
                                                            && $0.coordinate.latitude == annotation.coordinate.latitude } ? #imageLiteral(resourceName: "mapPinSelected") : #imageLiteral(resourceName: "mapPin")
        return view
    }
    
    /// selected
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? StoryAnnotation else { return }
        view.image = #imageLiteral(resourceName: "mapPinSelected")
        let old = mapView.selectedAnnotations.filter { $0.coordinate.longitude != annotation.coordinate.longitude
                                                        || $0.coordinate.latitude != annotation.coordinate.latitude }
        
        for a in old {
            mapView.deselectAnnotation(a, animated: false)
        }
        configureSelected(value: annotation.story)
        storyView.isHidden = false
    }
    
    /// deselected
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.image = #imageLiteral(resourceName: "mapPin")
        storyView.isHidden = mapView.selectedAnnotations.isEmpty
    }
    
}

/**
 * story annotation
 *
 * - author: TCCODER
 * - version: 1.0
 */
class StoryAnnotation: NSObject, MKAnnotation {
    
    /// fields
    var coordinate: CLLocationCoordinate2D
    var story: Story
    
    /// initializer
    init(story: Story) {
        self.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(story.lat), longitude: CLLocationDegrees(story.long))
        self.story = story
    }
    
}

/**
 * Story view
 *
 * - author: TCCODER
 * - version: 1.0
 */
class StoryView: UIView {
    
    /// fields
    @IBOutlet weak var storyImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var racetrackLabel: UILabel!
    @IBOutlet weak var shortDescriptionLabel: UILabel!
    @IBOutlet weak var chaptersLabel: UILabel!
    @IBOutlet weak var cardsLabel: UILabel!
    @IBOutlet weak var milesLabel: UILabel!
}
