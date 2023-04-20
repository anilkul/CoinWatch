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
        var favorites: [BaseCellPresentable] = []
        let pairList: [BaseCellPresentable] = list.data.map { PairPresentationObject(pair: $0) }
        dataSource = [favorites, pairList]
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
        return !(dataSource.first?.isEmpty ?? true)
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

typealias VoidHandler = () -> Void

extension Array {
  subscript(safe index: Int) -> Element? {
    return indices ~= index ? self[index] : nil
  }
}
