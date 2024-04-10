//
//  GameboardView.swift
//  2048AppVK
//
//  Created by Rafis on 05.04.2024.
//

import UIKit

final class GameboardView: UIView {
    // MARK: - Initialization
    init(with tiles: [[Tile]], and size: Int) {
        self.gameBoardSize = size
        
        super.init(frame: .zero)
        
        setupEmptyGameboard(of: gameBoardSize)
        
        setupUI()
        setFrames()
        setConstraints()
        
        restoreGameboard(with: tiles, and: gameBoardSize)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Constants
    private enum UIConstants {
        static let tileSpace: CGFloat = 4
        static let boardViewMargins: CGFloat = 32
        static let boardViewCornerRadius: CGFloat = 5
        
        static let resetButtonTopOffsetMultiplier: CGFloat = 10
    }
    
    // MARK: - Private Properties
    private let boardView = UIView()
    private var emptyTileViews = [[EmptyTileView]]()
    private var tileViews = [[TileView?]]()
    
    private let gameBoardSize: Int
    
    private let screenWidth = UIScreen.main.bounds.width
    private lazy var tileSize = ((screenWidth - 32) / 4) - UIConstants.tileSpace
    
    private let scoreTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Score"
        label.textColor = AppColor.gray
        label.font = AppFont.title2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let scoreValueLabel: UILabel = {
        let label = UILabel()
        label.text = "---"
        label.textColor = AppColor.label
        label.font = AppFont.title1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var scoreHStackView: UIStackView = {
        let hStack = UIStackView(arrangedSubviews: [scoreTextLabel, scoreValueLabel])
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.distribution = .fillEqually
        hStack.layer.cornerRadius = 5
        hStack.translatesAutoresizingMaskIntoConstraints = false
        return hStack
    }()
    
    private let restartButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.title = "Restart Game"
        config.baseBackgroundColor = AppColor.gray
        config.buttonSize = .large
        config.cornerStyle = .medium
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Methods
    func addTargetToRestartButton(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        restartButton.addTarget(target, action: action, for: controlEvents)
    }
    
    func setGameScore(_ gameScore: Int) {
        scoreValueLabel.text = String(gameScore)
    }
    
    func restartGameBoard() {
        setupEmptyGameboard(of: gameBoardSize)
        
        setupUI()
        setFrames()
        setConstraints()
    }
    
    func addRandomTile(_ randomTile: Tile) {
        guard randomTile.value > 0 else { return }
        let tileValue = randomTile.value
        
        let tileView = TileView()
        tileView.setTileValue(tileValue)
        
        tileViews[randomTile.positionY][randomTile.positionX] = tileView
        
        boardView.addSubview(tileView)
        
        putTileInPosition(row: randomTile.positionY, column: randomTile.positionX)
        
        UIView.animate(withDuration: 0.3) {
            tileView.transform = .init(scaleX: 0.7, y: 0.7)
        }
        UIView.animate(withDuration: 0.3, delay: 0.1) {
            tileView.transform = .init(scaleX: 1.0, y: 1.0)
        }
    }
    
    func shiftTiles(tiles: [[Tile]]) {
        tiles.enumerated().forEach { row, tileRows in
            tileRows.enumerated().forEach { column, tile in
                if let shiftingTileView = tileViews[row][column] {
                    
                    guard tile.newPositionX > -1 && tile.newPositionY > -1 else { return }
                    
                    let newPositionX = tile.newPositionX
                    let newPositionY = tile.newPositionY
                    let newTileValue = tiles[newPositionY][newPositionX].value
                    
                    let tileOnDestinationPoint = tileViews[newPositionY][newPositionX]
                    
                    shiftingTileView.setTileValue(newTileValue)
                    
                    tileViews[row][column] = nil
                    
                    tileOnDestinationPoint?.removeFromSuperview()
                    
                    tileViews[newPositionY][newPositionX] = shiftingTileView
                    
                    UIView.animate(withDuration: 0.25) {
                        self.putTileInPosition(row: newPositionY, column: newPositionX)
                    }
                }
            }
        }
    }
    
    // MARK: - Private Method
    private func putTileInPosition(row: Int, column: Int) {
        guard let newTileView = tileViews[row][column] else { return }
        let emptyTileView = emptyTileViews[row][column]
        
        // Перемещаемая плитка удаляется из прошлого родителя и помещятся к новому
        newTileView.removeFromSuperview()
        boardView.addSubview(newTileView)
        
        newTileView.frame = emptyTileView.frame
    }
    
    private func setupEmptyGameboard(of size: Int) {
        emptyTileViews = .init()
        
        for _ in 0..<size {
            var emptyTileViewRows = [EmptyTileView]()
            for _ in 0..<size {
                let emptyTileView = EmptyTileView()
                emptyTileViewRows.append(emptyTileView)
            }
            emptyTileViews.append(emptyTileViewRows)
        }
        tileViews = Array(repeating: Array(repeating: nil, count: size), count: size)
    }
    
    private func restoreGameboard(with tiles: [[Tile]], and size: Int) {
        tiles.enumerated().forEach { row, tileRows in
            tileRows.enumerated().forEach { column, tile in
                if tile.value > 0 {
                    
                    let restoredTileView = TileView()
                    restoredTileView.setTileValue(tile.value)
                    
                    tileViews[row][column] = restoredTileView
                    
                    putTileInPosition(row: row, column: column)
                }
            }
        }
    }
    
    private func setupUI() {
        backgroundColor = AppColor.background
        
        removeGameBoardSubviews()
        
        addSubview(boardView)
        addSubview(scoreHStackView)
        addSubview(restartButton)
        
        emptyTileViews.forEach { emptyTileViewRows in
            emptyTileViewRows.forEach { emptyTileView in
                boardView.addSubview(emptyTileView)
            }
        }
    }
    
    private func removeGameBoardSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
        boardView.subviews.forEach { $0.removeFromSuperview() }
    }
    
    private func setFrames() {
        let boardViewWidth = screenWidth - UIConstants.boardViewMargins
        boardView.frame = CGRect(x: 0, y: 0, width: boardViewWidth, height: boardViewWidth)
        boardView.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        
        emptyTileViews.enumerated().forEach { row, tileViewRows in
            tileViewRows.enumerated().forEach { column, tileView in
                
                let horisontalOffset = (tileSize + UIConstants.tileSpace) * CGFloat(column)
                let verticalOffset = (tileSize + UIConstants.tileSpace) * CGFloat(row)
                
                tileView.frame = CGRect(x: horisontalOffset, y: verticalOffset, width: tileSize, height: tileSize)
            }
        }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            scoreHStackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            scoreHStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            restartButton.topAnchor.constraint(
                equalToSystemSpacingBelow: boardView.bottomAnchor,
                multiplier: UIConstants.resetButtonTopOffsetMultiplier
            ),
            restartButton.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}
