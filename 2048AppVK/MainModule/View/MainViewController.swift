//
//  ViewController.swift
//  2048AppVK
//
//  Created by Rafis on 04.04.2024.
//

import UIKit
import Combine

final class MainViewController: UIViewController {
    
    // MARK: - Initialization
    init(viewModel: MainViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGestures()
        sinkToViewModel()
        setRandomTile()
    }
    
    // MARK: - Private Properties
    private let viewModel: MainViewModelProtocol
    
    private lazy var contentView: GameboardView = {
        let contentView = GameboardView(with: viewModel.tiles.value, and: viewModel.gameboardSize)
        contentView.isUserInteractionEnabled = true
        contentView.addTargetToRestartButton(self, action: #selector(didTapRestartButton), for: .touchUpInside)
        return contentView
    }()
    
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Private Methods
    private func setupGestures() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeGesture))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeGesture))
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeGesture))
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeGesture))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        upSwipe.direction = .up
        downSwipe.direction = .down
        
        contentView.addGestureRecognizer(leftSwipe)
        contentView.addGestureRecognizer(rightSwipe)
        contentView.addGestureRecognizer(upSwipe)
        contentView.addGestureRecognizer(downSwipe)
    }
    
    @objc
    private func didSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .left:
            viewModel.didLeftSwipeGesture()
            break
        case .right:
            viewModel.didRightSwipeGesture()
            break
        case .up:
            viewModel.didUpSwipeGesture()
            break
        case .down:
            viewModel.didDownSwipeGesture()
            break
        default:
            break
        }
        
        getGameScore()
    }
    
    @objc
    private func didTapRestartButton(_ sender: UIButton) {
        viewModel.didTapRestartButton()
        contentView.restartGameBoard()
        viewModel.setRandomTile()
        getGameScore()
    }
    
    private func sinkToViewModel() {
        viewModel.tiles
            .removeDuplicates()
            .combineLatest(viewModel.randomTile)
            .sink { [weak self] (tiles, randomTile) in
                self?.contentView.shiftTiles(tiles: tiles)
                if let randomTile = randomTile {
                    self?.contentView.addRandomTile(randomTile)
                }
            }
            .store(in: &subscriptions)
    }
    
    private func setRandomTile() {
        viewModel.setRandomTile()
        getGameScore()
    }
    
    private func getGameScore() {
        // Так как рандомная плитка ставится только после всех перемещений, то запрос Очков нужно выполнить тоже вконце
        DispatchQueue.main.async {
            let gameScore = self.viewModel.gameScore
            self.contentView.setGameScore(gameScore)
        }
    }
}

