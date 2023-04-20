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
        viewModel.requestPairList { [weak self] in
            self?.collectionView.dataSource = self
        }
    }
    
    private func registerCollectionViewComponents() {
        let identifier = String(describing: PairListCell.self)
        collectionView.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
        collectionView.register(UINib.init(nibName: String(describing: ListViewSectionHeader.self), bundle: nil),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: String(describing: ListViewSectionHeader.self))
    }
    
    private func setupViewModel() {
        let networkManager: NetworkManagable = NetworkManager()
        let dataProvider: ListViewDataProvidable = ListViewDataProvider(networkManager: networkManager)
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
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PairListCell.self), for: indexPath) as? PairListCell,
                let presentationObject = viewModel.presentationObject(at: indexPath) as? PairPresentable
            else {
              fatalError()
            }
            cell.populate(with: presentationObject)
            cell.delegate = viewModel
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
            let presentationObject = viewModel.presentationObject(at: indexPath) as? PairPresentable
            return presentationObject!.type.itemSize
        case .pairs:
            let presentationObject = viewModel.presentationObject(at: indexPath) as? PairPresentable
            return presentationObject!.type.itemSize
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.willDisplayCell(at: indexPath)
    }
}
