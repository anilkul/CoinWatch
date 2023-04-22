//
//  BaseViewController.swift
//  CoinWatch
//
//  Created by Anıl Kul on 22.04.2023.
//

import UIKit

class BaseViewController: UIViewController {
    private var blockView: UIView = UIView(frame: UIScreen.main.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blockView = UIView(frame: UIScreen.main.bounds)
        blockView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
    }
    
    func showActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = blockView.center
        activityIndicator.startAnimating()
        
        blockView.addSubview(activityIndicator)
        view.addSubview(blockView)
    }
    
    func hideActivityIndicator() {
        blockView.removeFromSuperview()
    }
}

