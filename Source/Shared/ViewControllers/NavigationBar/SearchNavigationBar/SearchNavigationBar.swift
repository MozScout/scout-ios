//
//  SearchNavigationBar.swift
//  Scout
//
//

import UIKit

class SearchNavigationBar: UIView {

    // MARK: - Private properties

    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var closeButton: UIButton!

    // MARK: - Public properties

    public var onClose: (() -> Void)?
    public var onTextDidChange: ((String) -> Void)?

    // MARK: -

    override func awakeFromNib() {
        super.awakeFromNib()

        setupView()
        setupSearchBar()
        setupCancelButton()
    }

    // MARK: - Public methods

    // MARK: - Private methods

    private func setupView() {
        backgroundColor = UIColor.clear
    }

    private func setupSearchBar() {
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.sfProText(.regular, ofSize: 12),
            .foregroundColor: UIColor.fxManatee
        ]
        let attributedPlaceholder = NSAttributedString(
            string: "Search by name or keywords",
            attributes: placeholderAttributes
        )

        textField.attributedPlaceholder = attributedPlaceholder
        textField.textColor = UIColor.fxWoodsmoke
        textField.font = UIFont.sfProText(.regular, ofSize: 12)
        textField.returnKeyType = .search
        textField.addTarget(
            self,
            action: #selector(textFieldEditingChanged),
            for: .editingChanged
        )
        textField.leftViewMode = .always
        textField.clearButtonMode = .always
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.borderStyle = .none
        textField.backgroundColor = UIColor.fxManatee.withAlphaComponent(0.12)
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true

        let searchImageView = UIImageView(image: #imageLiteral(resourceName: "Search bar icon"))
        searchImageView.contentMode = .scaleAspectFit
        searchImageView.snp.makeConstraints { (make) in
            make.height.equalTo(24)
            make.width.equalTo(32)
        }
        searchImageView.tintColor = UIColor.fxManatee

        textField.leftView = searchImageView
    }

    private func setupCancelButton() {
        closeButton.setTitle("Close", for: .normal)
        closeButton.titleLabel?.font = UIFont.openSans(ofSize: 14)
        closeButton.setTitleColor(UIColor.fxScienceBlue, for: .normal)
        closeButton.addTarget(
            self,
            action: #selector(cancelButtonAction),
            for: .touchUpInside
        )
    }

    @objc private func cancelButtonAction() {
        onClose?()
    }

    @objc private func textFieldEditingChanged() {
        onTextDidChange?(textField.text ?? "")
    }
}
