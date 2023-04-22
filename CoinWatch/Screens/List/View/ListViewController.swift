//
//  ListViewController.swift
//  CoinWatch
//
//  Created by Anıl Kul on 18.04.2023.
//

import UIKit

final class ListViewController: BaseViewController {
    // MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Variables
    private var viewModel: ListViewModelProtocol!
    private var activityIndicatorView = UIActivityIndicatorView()
    
    // MARK: - UI Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupBindings()
        registerCollectionViewComponents()
        viewModel.routingDelegate = self
        navigationController?.delegate = self
        showActivityIndicator()
        viewModel.requestPairList { [weak self] in
            self?.collectionView.dataSource = self
            self?.hideActivityIndicator()
        }
    }
    
    // MARK: - UI Operations
    private func registerCollectionViewComponents() {
        [PairListCell.self, FavoriteListHorizontalCell.self].forEach { cell in
            let identifier = String(describing: cell)
            collectionView.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
        }
        
        collectionView.register(UINib.init(nibName: String(describing: ListViewSectionHeader.self), bundle: nil),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: String(describing: ListViewSectionHeader.self))
    }
    
    // MARK: - Setup View Model
    private func setupViewModel() {
        let dataProvider: ListViewDataProvidable = DataProvider()
        viewModel = ListViewModel(dataProvider: dataProvider)
    }
    
    private func setupBindings() {
        viewModel.reloadData = reloadData()
    }
    
    private func reloadData() -> VoidHandler {
        return { [weak self] in
            guard let self = self else { return }
                self.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionType = SectionType(rawValue: indexPath.section) else {
            viewModel.log(error: GeneralError.enumInitializationError(rawValue: String(indexPath.section)))
            fatalError("Invalid enum")
        }
        switch sectionType {
        case .favorites:
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FavoriteListHorizontalCell.self), for: indexPath) as? FavoriteListHorizontalCell,
                let presentationObject = viewModel.presentationObject(at: indexPath) as? FavoriteListPresentable
            else {
                viewModel.log(error: UIError.cellCouldNotBeCreated(className: String(describing: FavoriteListHorizontalCell.self)))
                fatalError("Invalid cell")
            }
            cell.delegate = viewModel
            cell.populate(presentationObject: presentationObject)
            return cell
        case .pairs:
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PairListCell.self), for: indexPath) as? PairListCell,
                let presentationObject = viewModel.presentationObject(at: indexPath) as? PairPresentable
            else {
                viewModel.log(error: UIError.cellCouldNotBeCreated(className: String(describing: PairListCell.self)))
                fatalError("Invalid cell")
            }
            cell.delegate = viewModel
            cell.populate(with: presentationObject)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let sectionType = SectionType(rawValue: indexPath.section),
              let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: ListViewSectionHeader.self), for: indexPath) as? ListViewSectionHeader else {
          return UICollectionReusableView()
        }
        
        sectionHeader.populate(with: sectionType.title)
        return sectionHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let sectionType = SectionType(rawValue: section) else {
            return .zero
        }
        
        switch sectionType {
        case .favorites:
            return viewModel.isFavoritesSectionActive() ? sectionType.headerSize : .zero
        case .pairs:
            return sectionType.headerSize
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let sectionType = SectionType(rawValue: indexPath.section) else {
            viewModel.log(error: GeneralError.enumInitializationError(rawValue: String(indexPath.section)))
            fatalError("Invalid enum")
        }
        
        switch sectionType {
        case .favorites:
            guard viewModel.isFavoritesSectionActive() else {
                // .zero causes problems while hiding an item that stands for a section.
                return .negligibleSize
            }
            let presentationObject = viewModel.presentationObject(at: indexPath) as? FavoriteListPresentable
            return presentationObject?.type.itemSize ?? .negligibleSize
        case .pairs:
            let presentationObject = viewModel.presentationObject(at: indexPath) as? PairPresentable
            return presentationObject?.type.itemSize ?? .negligibleSize
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.willDisplayCell(at: indexPath)
    }
}

// MARK: - PairListCellDelegate
extension ListViewController: PairListCellDelegate {
    func didReceive(action: CellAction, presentationObject: PairPresentable) {
        viewModel.didReceive(action: action, presentationObject: presentationObject)
    }
}

// MARK: - DetailRoutingDelegate
extension ListViewController: DetailRoutingDelegate {
    func navigateToDetail(with viewModel: DetailViewModelProtocol) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: DetailViewController.self)
        guard let detailViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? DetailViewController else {
            self.viewModel.log(error: UIError.couldNotDefineController(identifier: identifier))
            fatalError("Invalid controller")
        }
        detailViewController.viewModel = viewModel
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - UINavigationControllerDelegate
extension ListViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let hide = viewController is ListViewController
        navigationController.setNavigationBarHidden(hide, animated: animated)
    }
}
