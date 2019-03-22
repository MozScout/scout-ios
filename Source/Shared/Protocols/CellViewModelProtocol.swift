import UIKit

// MARK: - Cell

protocol CellViewAnyModel {
    static var cellAnyType: UIView.Type { get }
    func setupAny(cell: UIView)
}

protocol CellViewModel: CellViewAnyModel {
    associatedtype CellType: UIView
    func setup(cell: CellType)
}

extension CellViewModel {
    static var cellAnyType: UIView.Type { return CellType.self }
    
    func setupAny(cell: UIView) {
        guard let castedCell = cell as? CellType else {
            fatalError("Cannot cast cell \(cell) to \(CellType.self)")
        }
        self.setup(cell: castedCell)
    }
}

extension UITableView {
    func dequeueReusableCell(
        with model: CellViewAnyModel,
        for indexPath: IndexPath
        ) -> UITableViewCell {

        let identifier = type(of: model).cellAnyType.defaultNibName()
        let cell = self.dequeueReusableCell(
            withIdentifier: identifier,
            for: indexPath
        )
        
        model.setupAny(cell: cell)
        
        return cell
    }
    
    func register(nibModels: [CellViewAnyModel.Type]) {
        for model in nibModels {
            let identifier = model.cellAnyType.defaultNibName()
            let cellNib = model.cellAnyType.defaultNib()
            self.register(cellNib, forCellReuseIdentifier: identifier)
        }
    }
    
    func register(classes: [CellViewAnyModel.Type]) {
        for model in classes {
            let identifier = model.cellAnyType.defaultNibName()
            self.register(model.cellAnyType, forCellReuseIdentifier: identifier)
        }
    }
}

extension UICollectionView {
    func dequeueReusableCell(with model: CellViewAnyModel, for indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = type(of: model).cellAnyType.defaultNibName()
        let cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)

        model.setupAny(cell: cell)

        return cell
    }

    func register(nibModels: [CellViewAnyModel.Type]) {
        for model in nibModels {
            let identifier = model.cellAnyType.defaultNibName()
            let cellNib = model.cellAnyType.defaultNib()
            self.register(cellNib, forCellWithReuseIdentifier: identifier)
        }
    }

    func register(classes: [CellViewAnyModel.Type]) {
        for model in classes {
            let identifier = model.cellAnyType.defaultNibName()
            self.register(model.cellAnyType, forCellWithReuseIdentifier: identifier)
        }
    }
}

// MARK: - Supplementary view

protocol SupplementaryViewAnyModel {
    static var viewAnyType: UIView.Type { get }
    static var kind: String { get }

    func setupAny(view: UIView)
}

protocol SupplementaryViewModel: SupplementaryViewAnyModel {
    associatedtype ViewType: UIView

    func setup(view: ViewType)
}

extension SupplementaryViewModel {
    static var viewAnyType: UIView.Type { return ViewType.self }

    func setupAny(view: UIView) {
        guard let castedView = view as? ViewType else {
            fatalError("Cannot cast decoration view \(view) to \(ViewType.self)")
        }
        self.setup(view: castedView)
    }
}

extension UICollectionView {

    func dequeueReusableSupplementaryView(
        with model: SupplementaryViewAnyModel,
        for indexPath: IndexPath
        ) -> UICollectionReusableView {

        let modelType = type(of: model)
        let identifier = modelType.viewAnyType.defaultNibName()
        let view = self.dequeueReusableSupplementaryView(
            ofKind: modelType.kind,
            withReuseIdentifier: identifier,
            for: indexPath
        )

        model.setupAny(view: view)

        return view
    }

    func register(nibModels: [SupplementaryViewAnyModel.Type]) {
        for model in nibModels {
            let identifier = model.viewAnyType.defaultNibName()
            let viewNib = model.viewAnyType.defaultNib()
            self.register(
                viewNib,
                forSupplementaryViewOfKind: model.kind,
                withReuseIdentifier: identifier
            )
        }
    }

    func register(classes: [SupplementaryViewAnyModel.Type]) {
        for model in classes {
            let identifier = model.viewAnyType.defaultNibName()
            self.register(
                model.viewAnyType,
                forSupplementaryViewOfKind: model.kind,
                withReuseIdentifier: identifier
            )
        }
    }
}
