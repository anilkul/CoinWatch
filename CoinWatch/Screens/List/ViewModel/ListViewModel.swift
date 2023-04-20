//
//  ListViewModel.swift
//  CoinWatch
//
//  Created by Anıl Kul on 18.04.2023.
//

import Foundation

final class ListViewModel: ListViewModelProtocol {
    private let dataProvider: ListViewDataProvidable
    private var dataSource: [[BaseCellPresentable]] = []
    private var treshold: Int = 0
    
    var reloadData: VoidHandler?
    
    init(dataProvider: ListViewDataProvidable) {
        self.dataProvider = dataProvider
    }
    
    func requestPairList(_ completion: VoidHandler?) {
        dataProvider.requestPairs { [weak self] response in
            switch response {
            case .success(let contentList):
                self?.parse(contentList)
                completion?()
                DispatchQueue.main.async {
                    self?.treshold += 20
                    self?.reloadData?()
                }
            case .failure(let error):
                #if DEBUG
                print(APIError.apiError(error: error))
                #endif
            }
        }
    }
    
    private func parse(_ list: PairList) {
        let favorites: [PairFavoritable] = dataProvider.fetchFavoriteList(fetchOffset: nil)
        let favroteList: [FavoriteListPresentable] = [FavoriteListPresentationObject(type: .horizontal, favorites: favorites)]
        let pairList: [PairPresentable] = list.data.map {
            let object = PairPresentationObject(type: .pair, pair: $0)
            object.isFavorite = favorites.contains(where: { $0.symbol == object.symbol })
            return object
            
        }
        dataSource = [favroteList, pairList]
    }
    
    func numberOfSections() -> Int {
        return SectionType.allCases.count
    }
    
    func numberOfItems(in section: Int) -> Int {
        guard
            section < dataSource.count
        else {
            return 0
        }
        switch SectionType(rawValue: section) {
        case .favorites:
            return dataSource[section].count
        case .pairs:
            return treshold
        case .none:
            return 0
        }
    }
    
    func presentationObject(at indexPath: IndexPath) -> BaseCellPresentable {
        dataSource[indexPath.section][indexPath.row]
    }
    
    func isFavoritesSectionActive() -> Bool {
        let favorites = (dataSource.first?.first as? FavoriteListPresentable)?.favorites
        return !(favorites?.isEmpty ?? true)
    }
    
    func willDisplayCell(at indexPath: IndexPath) {
        guard
            indexPath.section == SectionType.pairs.rawValue,
            indexPath.row == treshold - 1,
            treshold != dataSource[indexPath.section].count
        else {
            return
        }
        treshold = treshold + 20 < dataSource[indexPath.section].count
        ? treshold + 20
        : dataSource[indexPath.section].count
        DispatchQueue.main.async {
            self.reloadData?()
        }
    }
}

extension ListViewModel {
    func didReceive(action: CellAction, presentationObject: PairPresentable) {
        switch action {
        case .select:
            break
            // routing
        case .favorite:
            presentationObject.isFavorite.toggle()
            guard
                let favoritedObject = presentationObject as? FavoritePresentationObject,
                var favorites = dataSource[SectionType.favorites.rawValue] as? [PairFavoritable]
            else {
                return
            }
            if presentationObject.isFavorite {
                favorites.append(favoritedObject)
            } else {
                favorites.removeAll(where: { $0.symbol == favoritedObject.symbol })
            }
            
            dataProvider.setfavorite(presentationObject.isFavorite, favoritedObject) { [weak self] in
                self?.reloadData?()
            }
        }
    }
}

typealias VoidHandler = () -> Void

extension Array {
  subscript(safe index: Int) -> Element? {
    return indices ~= index ? self[index] : nil
  }
}
