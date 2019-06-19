//
//  MainViewController.swift
//  MovieDB
//
//  Created by cuonghx on 6/1/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

final class MainViewController: UITabBarController, BindableType {
    
    // MARK: - Propeties
    var viewModel: MainViewModel!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        logDeinit()
    }
    
    // MARK: - Methods
    func bindViewModel() {
        let input = MainViewModel.Input()
        let output = viewModel.transform(input)
        output.tabs
            .drive(rx.viewcontrollers)
            .disposed(by: rx.disposeBag)
    }
}

extension MainViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
