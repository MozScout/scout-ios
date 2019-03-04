//
//  EmptyView.swift
//  Scout
//
//

import UIKit

class SubscriptionsEmptyView: UIView {

    // MARK: - Private properties
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!

    // MARK: - Public properties

    public var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }

    // MARK: -

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setupTitleLabel()
        setupImageView()
    }

    private func setup() {
        contentView = loadViewFromNib()
        contentView.frame = bounds

        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        addSubview(contentView)
    }

    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            fatalError("Cannot get view from nib")
        }

        return view
    }

    // MARK: - Private methods

    private func setupTitleLabel() {
        titleLabel.textColor = UIColor.fxBlack
        titleLabel.font = UIFont.sfProText(.semibold, ofSize: 14)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
    }

    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit
    }
}
