//
//  ListViewController.swift
//  CoinWatch
//
//  Created by Anıl Kul on 18.04.2023.
//

import UIKit

final class ListViewController: UIViewController {
    // MARK: - Variables
    private var viewModel: ListViewModelProtocol!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - UI Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupBindings()
        registerCollectionViewComponents()
        viewModel.routingDelegate = self
        viewModel.requestPairList { [weak self] in
            self?.collectionView.dataSource = self
        }
        navigationController?.delegate = self
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
        let dataProvider: ListViewDataProvidable = ListViewDataProvider()
        viewModel = ListViewModel(dataProvider: dataProvider)
    }
    
    private func setupBindings() {
        viewModel.reloadData = reloadData()
    }
    
    func reloadData() -> VoidHandler {
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
            fatalError("Could not describe the section type")
        }
        switch sectionType {
        case .favorites:
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FavoriteListHorizontalCell.self), for: indexPath) as? FavoriteListHorizontalCell,
                let presentationObject = viewModel.presentationObject(at: indexPath) as? FavoriteListPresentable
            else {
              fatalError()
            }
            cell.delegate = viewModel
            cell.populate(presentationObject: presentationObject)
            return cell
        case .pairs:
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PairListCell.self), for: indexPath) as? PairListCell,
                let presentationObject = viewModel.presentationObject(at: indexPath) as? PairPresentable
            else {
              fatalError()
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
        
        sectionHeader.titleLabel.text = sectionType.title
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
            fatalError("Could not describe the section type")
        }
        
        switch sectionType {
        case .favorites:
            if !viewModel.isFavoritesSectionActive() {
                return .zero
            }
            let presentationObject = viewModel.presentationObject(at: indexPath) as? FavoriteListPresentable
            return presentationObject?.type.itemSize ?? .zero
        case .pairs:
            let presentationObject = viewModel.presentationObject(at: indexPath) as? PairPresentable
            return presentationObject?.type.itemSize ?? .zero
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
        guard let detailViewController = storyboard.instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as? DetailViewController else {
//          fatalError(ErrorLogger.UIError.couldNotDefineController(identifier: identifier).errorMessage(methodName: "\(#function)", fileName: "\(#file)"))
            fatalError()
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
