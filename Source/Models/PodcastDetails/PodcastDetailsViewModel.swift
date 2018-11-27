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
                     title: "IRL - Online Life Is Real Life",
                     author: "Mozilla",
                     lengthMinutes: 5,
                     sortID: 0,
                     resolvedURL: nil,
                     // swiftlint:disable:next line_length
                     articleImageURL: URL.init(string: "https://media.simplecast.com/podcast/image/3077/1541960426-artwork.jpg"),
                     url: "https://irlpodcast.org/",
                     publisher: "Mozilla",
                     iconURL: URL.init(string: "https://irlpodcast.org/images/favicon/favicon-196x196.png"),
                     isPodcast: true,
                     description: """
                     Our online life is real life. We walk, talk, work, LOL and even love on the Internet – but we \
                     don’t always treat it like real life. Host Manoush Zomorodi explores this disconnect with stories \
                     from the wilds of the Web and gets to the bottom of online issues that affect us all. Whether \
                     it’s privacy breaches, closed platforms, hacking, fake news, or cyberbullying, we the people have \
                     the power to change the course of the Internet, keeping it ethical, safe, weird, and wonderful \
                     for everyone. IRL is an original podcast from Mozilla.
                     """,
                     category: "Tech News",
                     latestEpisode: ("2018-11-26", "Checking Out Online Shopping")),
        ScoutArticle(withArticleID: "12",
                     title: "This American Life",
                     author: "This American Life",
                     lengthMinutes: 5,
                     sortID: 1,
                     resolvedURL: nil,
                     // swiftlint:disable:next line_length
                     articleImageURL: URL.init(string: "https://is3-ssl.mzstatic.com/image/thumb/Music118/v4/95/90/7d/95907d71-0f30-e954-c56b-279725ee60aa/source/170x170bb.jpg"),
                     url: "https://www.thisamericanlife.org/",
                     publisher: "This American Life",
                     // swiftlint:disable:next line_length
                     iconURL: URL.init(string: "https://www.thisamericanlife.org/sites/all/themes/thislife/favicons/favicon-32x32.png"),
                     isPodcast: true,
                     description: """
                     This American Life is a weekly public radio show, heard by 2.2 million people on more than 500 \
                     stations. Another 2.5 million people download the weekly podcast. It is hosted by Ira Glass, \
                     produced in collaboration with Chicago Public Media, delivered to stations by PRX The Public \
                     Radio Exchange, and has won all of the major broadcasting awards.
                     """,
                     category: "Personal Journals",
                     latestEpisode: ("2018-11-25", "492: Dr. Gilmer and Mr. Hyde")),
        ScoutArticle(withArticleID: "12",
                     title: "Serial",
                     author: "This American Life",
                     lengthMinutes: 5,
                     sortID: 2,
                     resolvedURL: nil,
                     // swiftlint:disable:next line_length
                     articleImageURL: URL.init(string: "https://is4-ssl.mzstatic.com/image/thumb/Music71/v4/61/59/94/615994ff-21b5-9817-3e89-09b7e012336d/source/170x170bb.jpg"),
                     url: "https://serialpodcast.org/",
                     publisher: "This American Life",
                     iconURL: URL.init(string: "https://serialpodcast.org/favicon.ico"),
                     isPodcast: true,
                     description: """
                     Serial is a podcast from the creators of This American Life, hosted by Sarah Koenig. Serial \
                     unfolds one story - a true story - over the course of a whole season. The show follows the plot \
                     and characters wherever they lead, through many surprising twists and turns. Sarah won't know \
                     what happens at the end of the story until she gets there, not long before you get there with \
                     her. Each week she'll bring you the latest chapter, so it's important to listen in, starting with \
                     Episode 1. New episodes are released on Thursday mornings.
                     """,
                     category: "News & Politics",
                     latestEpisode: ("2018-11-15", "S03 Episode 09: Some Time When Everything Has Changed")),
        ScoutArticle(withArticleID: "12",
                     title: "Radiolab",
                     author: "WNYC Studios",
                     lengthMinutes: 5,
                     sortID: 3,
                     resolvedURL: nil,
                     // swiftlint:disable:next line_length
                     articleImageURL: URL.init(string: "https://media.wnyc.org/i/raw/1/Radiolab_WNYCStudios_1400_2dq02Dh.png"),
                     url: "https://www.wnycstudios.org/shows/radiolab",
                     publisher: "WNYC Studios",
                     iconURL: URL.init(string: "https://www.wnycstudios.org/favicon.ico"),
                     isPodcast: true,
                     description: """
                     A two-time Peabody Award-winner, Radiolab is an investigation told through sounds and stories, \
                     and centered around one big idea. In the Radiolab world, information sounds like music and \
                     science and culture collide. Hosted by Jad Abumrad and Robert Krulwich, the show is designed for \
                     listeners who demand skepticism, but appreciate wonder. WNYC Studios is a listener-supported \
                     producer of other leading podcasts including On the Media, Snap Judgment, Death, Sex & Money, \
                     Nancy and Here’s the Thing with Alec Baldwin. © WNYC Studios
                     """,
                     category: "Natural Sciences",
                     latestEpisode: ("2018-11-21", "UnErased: Dr. Davison and the Gay Cure")),
        ScoutArticle(withArticleID: "12",
                     title: "Planet Money",
                     author: "NPR",
                     lengthMinutes: 5,
                     sortID: 4,
                     resolvedURL: nil,
                     // swiftlint:disable:next line_length
                     articleImageURL: URL.init(string: "https://media.npr.org/assets/img/2018/08/02/npr_planetmoney_podcasttile_sq-7b7fab0b52fd72826936c3dbe51cff94889797a0-s400-c85.jpg"),
                     url: "https://www.npr.org/podcasts/510289/planet-money",
                     publisher: "NPR",
                     iconURL: URL.init(string: "https://media.npr.org/templates/favicon/favicon-180x180.png"),
                     isPodcast: true,
                     description: """
                     The economy explained. Imagine you could call up a friend and say, "Meet me at the bar and tell \
                     me what's going on with the economy." Now imagine that's actually a fun evening.
                     """,
                     category: "Business",
                     latestEpisode: ("2018-11-23", "#878: Mugshots For Sale")),
        ScoutArticle(withArticleID: "12",
                     title: "Invisibilia",
                     author: "NPR",
                     lengthMinutes: 5,
                     sortID: 5,
                     resolvedURL: nil,
                     // swiftlint:disable:next line_length
                     articleImageURL: URL.init(string: "https://media.npr.org/assets/img/2018/08/03/npr_invisibilia_podcasttile_sq-1c4d3c46584f71f04dc5b913c3cb8c08c0209f66-s400-c85.jpg"),
                     url: "https://www.npr.org/podcasts/510307/invisibilia",
                     publisher: "NPR",
                     iconURL: URL.init(string: "https://media.npr.org/templates/favicon/favicon-180x180.png"),
                     isPodcast: true,
                     description: """
                     Unseeable forces control human behavior and shape our ideas, beliefs, and assumptions. \
                     Invisibilia—Latin for invisible things—fuses narrative storytelling with science that will make \
                     you see your own life differently.
                     """,
                     category: "Science & Medicine",
                     latestEpisode: ("2018-10-16", "BONUS: Who Do You Let In?"))

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

        /*
        if profile.season1 != nil {
            let season1 = PodcastDetailsViewModelSeason1Item()
            items.append(season1)
        }
        */
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
                                                            for: indexPath) as? MyListTableViewCell {
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
    var image: UIImage
    var website: URL?
    var category: String

    init(about: String) {
        self.about = """
        Chris Lighty was a giant in hip-hop. He managed Foxy Brown, Fat Joe, Missy Elliott, Busta Rhymes, LL Cool J, \
        50 Cent—anyone who was anyone worked with Lighty. But in 2012 he was found dead at his home in the Bronx, a \
        death that left the music world reeling. In this podcast miniseries from Gimlet Media and Loud Speakers \
        Network, we tell the story of Chris Lighty, from the first breakbeat to the last heartbeat.
        """
        self.image = UIImage.init(named: "podcasts")!
        self.category = "Unknown"
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
