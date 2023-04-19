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
    
    // MARK: - UI Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
    }
    
    private func setupViewModel() {
        let networkManager: NetworkManagable = NetworkManager()
        let dataProvider: ListViewDataProvidable = ListViewDataProvider(networkManager: networkManager)
        viewModel = ListViewModel(dataProvider: dataProvider)
    }
}
