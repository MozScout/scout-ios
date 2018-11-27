//
//  PodcastsViewController.swift
//  Scout
//
//

import UIKit

protocol PodcastsDelegate: class {
    func openPodcastDetails(_ article: ScoutArticle?)
    func openAddPodcasts()
}

class PodcastsViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var gradientButton: GradientButton!
    @IBOutlet private weak var handsFreeButton: UIButton!

    weak var podcastsDelegate: PodcastsDelegate?
    weak var voiceInputDelegateFromMain: VoiceInputDelegate?
    private var spinner: UIActivityIndicatorView?
    private let cellRowReuseId = "cellrow"
    private let collectionRowReuseId = "collectionCell"
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
                     excerpt: """
                     Our online life is real life. We walk, talk, work, LOL and even love on the Internet – but we \
                     don’t always treat it like real life. Host Manoush Zomorodi explores this disconnect with stories \
                     from the wilds of the Web and gets to the bottom of online issues that affect us all. Whether \
                     it’s privacy breaches, closed platforms, hacking, fake news, or cyberbullying, we the people have \
                     the power to change the course of the Internet, keeping it ethical, safe, weird, and wonderful \
                     for everyone. IRL is an original podcast from Mozilla.
                     """,
                     isPodcast: true,
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
                     excerpt: """
                     This American Life is a weekly public radio show, heard by 2.2 million people on more than 500 \
                     stations. Another 2.5 million people download the weekly podcast. It is hosted by Ira Glass, \
                     produced in collaboration with Chicago Public Media, delivered to stations by PRX The Public \
                     Radio Exchange, and has won all of the major broadcasting awards.
                     """,
                     isPodcast: true,
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
                     excerpt: """
                     Serial is a podcast from the creators of This American Life, hosted by Sarah Koenig. Serial \
                     unfolds one story - a true story - over the course of a whole season. The show follows the plot \
                     and characters wherever they lead, through many surprising twists and turns. Sarah won't know \
                     what happens at the end of the story until she gets there, not long before you get there with \
                     her. Each week she'll bring you the latest chapter, so it's important to listen in, starting with \
                     Episode 1. New episodes are released on Thursday mornings.
                     """,
                     isPodcast: true,
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
                     excerpt: """
                     A two-time Peabody Award-winner, Radiolab is an investigation told through sounds and stories, \
                     and centered around one big idea. In the Radiolab world, information sounds like music and \
                     science and culture collide. Hosted by Jad Abumrad and Robert Krulwich, the show is designed for \
                     listeners who demand skepticism, but appreciate wonder. WNYC Studios is a listener-supported \
                     producer of other leading podcasts including On the Media, Snap Judgment, Death, Sex & Money, \
                     Nancy and Here’s the Thing with Alec Baldwin. © WNYC Studios
                     """,
                     isPodcast: true,
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
                     excerpt: """
                     The economy explained. Imagine you could call up a friend and say, "Meet me at the bar and tell \
                     me what's going on with the economy." Now imagine that's actually a fun evening.
                     """,
                     isPodcast: true,
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
                     excerpt: """
                     Unseeable forces control human behavior and shape our ideas, beliefs, and assumptions. \
                     Invisibilia—Latin for invisible things—fuses narrative storytelling with science that will make \
                     you see your own life differently.
                     """,
                     isPodcast: true,
                     category: "Science & Medicine",
                     latestEpisode: ("2018-10-16", "BONUS: Who Do You Let In?"))
    ]
    var scoutClient: ScoutHTTPClient!
    var keychainService: KeychainService!

    var selectedIndex = IndexPath()
    var userID: String = ""
    var expandedRows = Set<Int>()
    fileprivate var articleNumber: Int = 0

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(self.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.black

        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: Private
    fileprivate func configureUI() {
        spinner = self.addSpinner()
        tableView.addSubview(self.refreshControl)

        gradientButton.direction = .horizontally(centered: 0.1)
        tableView.dataSource = self
        collectionView.dataSource = self
        tableView.register(UINib(nibName: "MyListTableViewCell", bundle: nil),
                           forCellReuseIdentifier: cellRowReuseId)
        collectionView.register(UINib(nibName: "PodcastsCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: collectionRowReuseId)
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension
        // tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self.bottomLayoutGuide.length, right: 0)
    }

    func addSpinner() -> UIActivityIndicatorView {
        // Adding spinner over launch screen
        let spinner = UIActivityIndicatorView.init()
        spinner.style = UIActivityIndicatorView.Style.whiteLarge
        spinner.color = UIColor.black
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        self.view.addSubview(spinner)

        let xConstraint = NSLayoutConstraint(item: spinner,
                                             attribute: .centerX,
                                             relatedBy: .equal,
                                             toItem: self.view,
                                             attribute: .centerX,
                                             multiplier: 1,
                                             constant: 0)
        let yConstraint = NSLayoutConstraint(item: spinner,
                                             attribute: .centerY,
                                             relatedBy: .equal,
                                             toItem: self.view,
                                             attribute: .centerY,
                                             multiplier: 1,
                                             constant: 0)

        NSLayoutConstraint.activate([xConstraint, yConstraint])

        self.view.bringSubviewToFront(spinner)

        return spinner
    }

    func showHUD() {
        DispatchQueue.main.async {
            self.spinner?.startAnimating()
            self.tableView.isUserInteractionEnabled = false
        }
    }

    func hideHUD() {
        DispatchQueue.main.async {
            self.spinner?.stopAnimating()
            self.tableView.isUserInteractionEnabled = true
        }
    }

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    @IBAction func addPodcastsButtonTapped(_ sender: Any) {
        guard let requiredDelegate = self.podcastsDelegate else { return }
        requiredDelegate.openAddPodcasts()
    }
}

extension PodcastsViewController: UITableViewDataSource, UITableViewDelegate, MyListTableViewCellDelegate {
    func playButtonTapped() {
    }

    func skimButtonTapped() {
        guard let requiredDelegate = self.podcastsDelegate else { return }
        requiredDelegate.openPodcastDetails(self.scoutTitles![articleNumber])
    }

    func archiveButtonTapped() {
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.scoutTitles != nil {
            return self.scoutTitles!.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellRowReuseId,
                                                 // swiftlint:disable:next force_cast
                                                 for: indexPath) as! MyListTableViewCell

        self.selectedIndex = []
        cell.playButtonDelegate = self
        cell.skimButtonDelegate = self
        cell.archiveButtonDelegate = self
        cell.configureCell(withModel: self.scoutTitles![indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? MyListTableViewCell else { return }

        if cell.isExpanded {
            self.expandedRows.remove(indexPath.row)
            selectedIndex = []
        } else {
            self.expandedRows.insert(indexPath.row)
            articleNumber = indexPath.row
            selectedIndex = indexPath
        }

        cell.isExpanded = !cell.isExpanded

        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        self.tableView.scrollToRow(at: indexPath, at: .none, animated: false)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedIndex {
            return 145.0
        }
        return 100.0
    }
}

extension PodcastsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionRowReuseId,
                                                      // swiftlint:disable:next force_cast
                                                      for: indexPath) as! PodcastsCollectionViewCell
        cell.configureCell(self.scoutTitles![indexPath.item])
        return cell
    }

    @IBAction func handsFreeButtonTapped(_ sender: Any) {
        DispatchQueue.main.async {
            guard let requiredDelegate = self.voiceInputDelegateFromMain else { return }
            requiredDelegate.openVoiceInputFromMain()
        }
    }
}
