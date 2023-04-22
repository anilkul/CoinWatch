//
//  ListViewModel.swift
//  CoinWatch
//
//  Created by Anıl Kul on 18.04.2023.
//

import Foundation

final class ListViewModel: BaseViewModel, ListViewModelProtocol {
    // MARK: - Variables
    private let dataProvider: ListViewDataProvidable
    private var dataSource: [[BaseCellPresentable]] = []
    private var treshold: Int = 0
    
    var reloadData: VoidHandler?
    weak var routingDelegate: DetailRoutingDelegate?
    
    // MARK: - Initialization
    init(dataProvider: ListViewDataProvidable) {
        self.dataProvider = dataProvider
    }
    
    // MARK: - Pair List Operations
    func requestPairList(_ completion: VoidHandler?) {
        dataProvider.requestPairs { [weak self] response in
            switch response {
            case .success(let pairList):
                self?.parse(pairList)
                completion?()
                DispatchQueue.main.async {
                    self?.treshold += 20
                    self?.reloadData?()
                }
            case .failure(let error):
                self?.errorLogger.logError(APIError.apiError(error: error))
            }
        }
    }
    
    private func parse(_ list: PairList) {
        let favorites: [PairFavoritable] = dataProvider.fetchFavoriteList(fetchOffset: nil)
        let favroteList: [FavoriteListPresentable] = [FavoriteListPresentationObject(type: .horizontal, favorites: favorites)]
        let pairList: [PairPresentable] = list.data.map {
            let object = PairPresentationObject(pair: $0)
            object.isFavorite = favorites.contains(where: { $0.symbol == object.symbol })
            return object
        }
        
        dataSource = [favroteList, pairList]
    }
    
    // MARK: - Data Source Operations
    func numberOfSections() -> Int {
        return SectionType.allCases.count
    }
    
    func numberOfItems(in section: Int) -> Int {
        guard section < dataSource.count else {
            return 0
        }
        guard let sectionType = SectionType(rawValue: section) else {
            errorLogger.logError(GeneralError.enumInitializationError(rawValue: section.description))
            return 0
        }
        switch sectionType {
        case .favorites:
            return isFavoritesSectionActive() ? dataSource[section].count : 0
        case .pairs:
            return treshold
        }
    }
    
    func presentationObject(at indexPath: IndexPath) -> BaseCellPresentable {
        dataSource[indexPath.section][indexPath.row]
    }
    
    func isFavoritesSectionActive() -> Bool {
        if let favorites = (dataSource[SectionType.favorites.rawValue].first as? FavoriteListPresentable)?.favorites {
            return !favorites.isEmpty
        }
        return false
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

// MARK: - Actions
extension ListViewModel {
    // Pair List Cell Action
    func didReceive(action: CellAction, presentationObject: PairPresentable) {
        switch action {
        case .select:
            navigateToDetail(for: presentationObject.symbol, with: presentationObject.name)
        case .favorite:
            presentationObject.isFavorite.toggle()
            guard
                let favoriteListObject = dataSource[SectionType.favorites.rawValue].first as? FavoriteListPresentable
            else {
                errorLogger.logError(GeneralError.invalidCast)
                return
            }
            let favoritedPairObject = FavoritePresentationObject(pair: presentationObject)
            if presentationObject.isFavorite {
                favoriteListObject.favorites.append(favoritedPairObject)
            } else {
                favoriteListObject.favorites.removeAll(where: { $0.symbol == favoritedPairObject.symbol })
            }
            
            let newFavoriteList = favoriteListObject.favorites as? [FavoritePresentationObject] ?? []
            do {
                try dataProvider.setfavorites(presentationObject.isFavorite, newFavoriteList) { [weak self] in
                    DispatchQueue.main.async {
                        self?.reloadData?()
                    }
                }
            } catch {
                errorLogger.logError(error)
            }
        }
    }
    
    // Favorite Cell Action
    func didReceive(action: CellAction, presentationObject: PairFavoritable) {
        switch action {
        case .select:
            navigateToDetail(for: presentationObject.symbol, with: presentationObject.name)
        default:
            break
        }
    }
    
    // MARK: - Navigation
    private func navigateToDetail(for symbol: String, with name: String) {
        let viewModel = DetailViewModel(name: name, symbol: symbol, dataProvider: dataProvider)
        routingDelegate?.navigateToDetail(with: viewModel)
    }
}
