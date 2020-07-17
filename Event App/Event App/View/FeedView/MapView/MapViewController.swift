//
//  MapViewController.swift
//  Event App
//
//  Created by Admin on 29.03.2020.
//  Copyright © 2020 eventapp. All rights reserved.
//

import MapKit
import Reusable
import UIKit
import XLPagerTabStrip

class MapViewController: UIViewController, IndicatorInfoProvider {
    let locationManager = CLLocationManager()
    let regionMeters: Double = 10000
    var filteredEvents = [Event]()
    //swiftlint:disable implicitly_unwrapped_optional
    var presenter: MapViewPresenter!
    var searchBar: UISearchBar!
    var userCity = City.msk
    //swiftlint:enable implicitly_unwrapped_optional
    @IBOutlet private var mapView: MKMapView!
    @IBOutlet private var detailsView: MapDetailsView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(triggerTouchAction))
        mapView.addGestureRecognizer(gestureRecognizer)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //swiftlint:disable force_cast
        let delegate = UIApplication.shared.delegate as! AppDelegate
        userCity = City.allCases[UserDefaults.standard.object(forKey: "USER_CITY") as? Int ?? 0]
        if !delegate.viewsToReload.contains(self) {
            delegate.viewsToReload.append(self)
        }
        //swiftlint:enable force_cast
        checkLocationServices()
        presenter = MapViewPresenter(view: self)
        presenter.getEvents(city: userCity) {
            for event in self.filteredEvents {
                let annotation = MKPointAnnotation()
                annotation.title = event.title
                guard let coordinates = event.place?.coords else {
                    continue
                }
                annotation.coordinate = CLLocationCoordinate2D(latitude: coordinates.lat, longitude: coordinates.lon)
                self.mapView.addAnnotation(annotation)
            }
        }
        mapView.delegate = self
        setUpDetails()
     }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
      IndicatorInfo(title: "Карта")
    }

    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setUpLocationManager()
            checkLocationAuthorization()
        } else {
            let alertController = UIAlertController(
                title: "Location services are turned off",
                message: "Please turn on location services in settings in order to use the map",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
        }
    }

    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
            mapView.setRegion(region, animated: true)
        }
    }

    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }

    func getLocation() -> LocationArea {
        let center = mapView.region.center
        let coordinates = CLLocationCoordinate2D(latitude: center.latitude, longitude: center.longitude)
        return LocationArea(lat: coordinates.latitude, lon: coordinates.longitude)
    }

    func setUpDetails() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        detailsView.addGestureRecognizer(tap)
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        let viewController = DetailsViewController.instantiate() as DetailsViewController
        viewController.event = detailsView.event
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc func triggerTouchAction(gestureReconizer: UITapGestureRecognizer) {
        detailsView.isHidden = true
    }
    @objc func didTapPin(gestureRecognizer: UITapGestureRecognizer) {
    }
}
extension MapViewController: StoryboardBased {
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
        mapView.setRegion(region, animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        if !(searchBar.text?.isEmpty ?? true) {
            return
        }
        let prevAnnotations = mapView.annotations
        presenter.getEvents(city: userCity) {
            for event in self.filteredEvents {
                guard let coordinates = event.place?.coords else {
                    continue
                }
                let foundCoordinate = CLLocationCoordinate2D(latitude: coordinates.lat, longitude: coordinates.lon)
                let annotation = EventAnnotation(coordinate: foundCoordinate)
                annotation.title = event.title
                annotation.event = event
                self.mapView.addAnnotation(annotation)
            }
            DispatchQueue.main.async {
                mapView.removeAnnotations(prevAnnotations)
            }
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        }
        annotationView?.canShowCallout = true
        annotationView?.image = #imageLiteral(resourceName: "Group 6.1")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapPin))
        annotationView?.addGestureRecognizer(tapGesture)
        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let view = view.annotation as? EventAnnotation else {
            return
        }
        guard let event = view.event else {
            return
        }
        detailsView.setup(with: event)
        detailsView.isHidden = false
        let location = view.coordinate
        DispatchQueue.main.async {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: self.regionMeters / 5, longitudinalMeters: self.regionMeters / 5)
            mapView.setRegion(region, animated: true)
        }
    }

    func searchBarTextChanged(searchText: String) {
        let buf = filteredEvents
        if presenter == nil {
            return
        }
        filteredEvents = presenter.filter(with: searchText)
        let changes = presenter.getDiff(old: filteredEvents, new: buf)
        if !changes.0.isEmpty {
            let annotationsToRemove = mapView.annotations.filter {
                guard let annotation = $0 as? EventAnnotation else {
                    return false
                }
                guard let event = annotation.event else {
                    return false
                }
                return changes.0.contains(event)
            }
            mapView.removeAnnotations(annotationsToRemove)
        }
        if !changes.1.isEmpty {
            for change in changes.1 {
                guard let coordinates = change.place?.coords else {
                    continue
                }
                let annotation = EventAnnotation(coordinate: CLLocationCoordinate2D(latitude: coordinates.lat, longitude: coordinates.lon))
                annotation.event = change
                mapView.addAnnotation(annotation)
            }
        }
    }
}
