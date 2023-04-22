//
//  FavoriteListHorizontalCell.swift
//  CoinWatch
//
//  Created by Anıl Kul on 20.04.2023.
//

import UIKit

class FavoriteListHorizontalCell: UICollectionViewCell {
    // MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Variables
    private var errorLogger: ErrorLoggable!
    private var presentationObject: FavoriteListPresentable!
    weak var delegate: FavoriteListHorizontalCellDelegate?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        let identifier = String(describing: FavoriteCell.self)
        collectionView.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
    
    // MARK: - Setup
    func populate(presentationObject: FavoriteListPresentable, errorLogger: ErrorLogger = ErrorLogger()) {
        self.presentationObject = presentationObject
        self.errorLogger = errorLogger
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension FavoriteListHorizontalCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presentationObject.favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FavoriteCell.self), for: indexPath) as? FavoriteCell
        else {
            errorLogger.logError(UIError.cellCouldNotBeCreated(className: String(describing: FavoriteCell.self)))
            fatalError()
        }
        let presentationObject = presentationObject.favorites[indexPath.row]
        cell.populate(presentationObject: presentationObject)
        cell.delegate = self
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FavoriteListHorizontalCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let presentationObject = presentationObject.favorites[indexPath.row]
        return self.presentationObject.favorites.isEmpty ? .negligibleSize : presentationObject.type.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 24, bottom: 0, right: 24)
    }
}

extension FavoriteListHorizontalCell: FavoriteCellDelegate {
    func didReceive(action: CellAction, presentationObject: PairFavoritable) {
        delegate?.didReceive(action: action, presentationObject: presentationObject)
    }
}
