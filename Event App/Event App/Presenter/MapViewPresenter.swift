import DeepDiff
import Foundation

class MapViewPresenter {
    typealias OnActionCompletion = () -> Void

    var view: MapViewController
    var facade: EventFacade
    var events = [Event]()

    init (view: MapViewController, facade: EventFacade = EventFacadeImpl(service: EventServiceImpl())) {
        self.facade = facade
        self.view = view
    }

    func getEvents(city: City, completion: @escaping OnActionCompletion) {
        facade.getEventsInArea(city: city, locationArea: view.getLocation()) { events in
            guard let events = events else {
                completion()
                return
            }
            self.events = events
            self.view.filteredEvents = events
            completion()
        }
    }

    func getDiff(old: [Event], new: [Event]) -> ([Event], [Event]) {
        let differences = diff(old: old, new: new)
        var deletions = [Event]()
        var insertions = [Event]()
        for difference in differences {
            if let deletion = difference.delete?.item {
                deletions.append(deletion)
            }
            if let insertion = difference.insert?.item {
                insertions.append(insertion)
            }
        }
       return (insertions, deletions)
    }

    func filter(with query: String) -> [Event] {
        if query.isEmpty {
            return events
        } else {
            return events.filter {
                $0.title.lowercased().contains(query.lowercased())
            }
        }
    }
}
