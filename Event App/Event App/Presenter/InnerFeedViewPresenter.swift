import DeepDiff
import Foundation

class InnerFeedViewPresenter {
    typealias OnActionCompletion = () -> Void

    var events = [Event]()
    var view: InnerFeedViewController
    var facade: EventFacade

    init (view: InnerFeedViewController, facade: EventFacade = EventFacadeImpl(service: EventServiceImpl(), repository: EventRepositoryImpl())) {
        self.facade = facade
        self.view = view
    }

    func getEvents(city: City, completion: @escaping OnActionCompletion) {
        facade.getEvents(city: city) { events in
            guard let events = events else {
                completion()
                return
            }
            self.events = events
            self.view.filteredEvents = self.events
            completion()
        }
    }
    func getEventsWithCategory(city: City, category: EventCategory, completion: @escaping OnActionCompletion) {
        facade.getEventsWithCategory(city: city, category: category) { events in
            guard let events = events else {
                completion()
                return
            }
            self.events = events
            self.view.filteredEvents = self.events
            completion()
        }
    }

    func loadMore(completion: @escaping OnActionCompletion) {
        facade.getMoreEvents { events in
            guard let events = events else {
                completion()
                return
            }
            self.events.append(contentsOf: events)
            self.view.filteredEvents = self.events
            completion()
            self.view.reloadTableView()
        }
    }

    func getDiff(old: [Event], new: [Event]) -> ([IndexPath], [IndexPath]) {
        let differences = diff(old: old, new: new)
        var deletions = [IndexPath]()
        var insertions = [IndexPath]()
        for difference in differences {
            if let deletion = difference.delete?.index {
                deletions.append(IndexPath(row: deletion, section: 0))
            }
            if let insertion = difference.insert?.index {
                insertions.append(IndexPath(row: insertion, section: 0))
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
