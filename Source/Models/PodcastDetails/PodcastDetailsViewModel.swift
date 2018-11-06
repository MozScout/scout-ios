//
//

import Foundation
import UIKit

enum PodcastDetailsViewModelItemType {
    // swiftlint:disable:next identifier_name
    case About
    // swiftlint:disable:next identifier_name
    case Season1
}

protocol PodcastDetailsViewModelItem {
    var type: PodcastDetailsViewModelItemType { get }
    var sectionTitle: String { get }
    var rowCount: Int { get }
    var isCollapsible: Bool { get }
    var isCollapsed: Bool { get set }
}

extension PodcastDetailsViewModelItem {
    var rowCount: Int {
        return 1
    }

    var isCollapsible: Bool {
        return true
    }
}

class PodcastDetailsViewModel: NSObject {
    var items = [PodcastDetailsViewModelItem]()

    var reloadSections: ((_ section: Int) -> Void)?
    private var scoutTitles: [ScoutArticle]? = [
        ScoutArticle(withArticleID: "12",
                     title: "Test",
                     author: "Test",
                     lengthMinutes: 5,
                     sortID: 4,
                     resolvedURL: nil,
                     articleImageURL: nil,
                     url: "",
                     publisher: "",
                     iconURL: nil),
        ScoutArticle(withArticleID: "12",
                     title: "Test2",
                     author: "Test2",
                     lengthMinutes: 5,
                     sortID: 4,
                     resolvedURL: nil,
                     articleImageURL: nil,
                     url: "",
                     publisher: "",
                     iconURL: nil)
    ]
    override init() {
        super.init()

        guard let data = dataFromFile("ServerData"), let profile = PodcastDetails(data: data) else {
            return
        }
        if let about = profile.about {
            let aboutItem = PodcastDetailsViewModelAboutItem(about: about)
            items.append(aboutItem)
        }

        if profile.season1 != nil {
            let season1 = PodcastDetailsViewModelSeason1Item()
            items.append(season1)
        }
    }
}

extension PodcastDetailsViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let item = items[section]
        guard item.isCollapsible else {
            return item.rowCount
        }

        if item.isCollapsed {
            return 0
        } else {
            return item.rowCount
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        switch item.type {
        case .About:
            if let cell = tableView.dequeueReusableCell(withIdentifier: AboutCell.identifier,
                                                        for: indexPath) as? AboutCell {
                cell.item = item
                return cell
            }
        case .Season1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cellrow",
                                                        for: indexPath) as? PlayMyListTableViewCell {
                cell.configureCell(withModel: self.scoutTitles![indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
}

extension PodcastDetailsViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: HeaderView.identifier) as? HeaderView {
            let item = items[section]

            headerView.item = item
            headerView.section = section
            headerView.delegate = self
            return headerView
        }
        return UIView()
    }
}

extension PodcastDetailsViewModel: HeaderViewDelegate {
    func toggleSection(header: HeaderView, section: Int) {
        var item = items[section]
        if item.isCollapsible {

            // Toggle collapse
            let collapsed = !item.isCollapsed
            item.isCollapsed = collapsed
            //header.setCollapsed(collapsed: collapsed)

            // Adjust the number of the rows inside the section
            reloadSections?(section)
        }
    }
}

class PodcastDetailsViewModelAboutItem: PodcastDetailsViewModelItem {

    var type: PodcastDetailsViewModelItemType {
        return .About
    }

    var sectionTitle: String {
        return "About"
    }

    var isCollapsed = false
    var about: String

    init(about: String) {
        self.about = """
        Chris Lighty was a giant in hip-hop. He managed Foxy Brown, Fat Joe, Missy Elliott, Busta Rhymes, LL Cool J, \
        50 Cent—anyone who was anyone worked with Lighty. But in 2012 he was found dead at his home in the Bronx, a \
        death that left the music world reeling. In this podcast miniseries from Gimlet Media and Loud Speakers \
        Network, we tell the story of Chris Lighty, from the first breakbeat to the last heartbeat.
        """
    }
}

class PodcastDetailsViewModelSeason1Item: PodcastDetailsViewModelItem {
    var type: PodcastDetailsViewModelItemType {
        return .Season1
    }

    var sectionTitle: String {
        return "Season 1"
    }

    var isCollapsed = true

    var rowCount: Int {
        return 2
    }

}
