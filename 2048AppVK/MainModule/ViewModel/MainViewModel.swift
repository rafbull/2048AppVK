//
//  MainViewModel.swift
//  2048AppVK
//
//  Created by Rafis on 04.04.2024.
//

import Foundation
import Combine

final class MainViewModel: MainViewModelProtocol {
    
    // MARK: - Properties
    var tiles = CurrentValueSubject<[[Tile]], Never>([])
    var randomTile = CurrentValueSubject<Tile?, Never>(nil)
    
    let gameboardSize = AppConstants.gameboardSize
    
    var gameScore: Int {
        var score: Int = 0
        tiles.value.flatMap({ $0 }).compactMap({ $0.value }).forEach{ score += $0 }
        return score
    }
    
    private var updatingGameBoard = false
    
    private lazy var coreDataManager = CoreDataManager.shared
    
    // MARK: - Initialization
    init() {
        self.fetchTilesFromCoreData()
    }
    
    // MARK: - Methods
    func setRandomTile() {
        // Поиск "пустой" плитки на поле
        guard let randomEmptyTile = tiles.value
            .flatMap({ $0 }).filter({ $0.value == 0 })
            .filter({ $0.positionY != randomTile.value?.positionY || $0.positionX != randomTile.value?.positionX })
            .randomElement()
        else { return }
        
        
        randomEmptyTile.value = 2
        randomEmptyTile.newPositionY = -1
        randomEmptyTile.newPositionX = -1
        
        tiles.value[randomEmptyTile.positionY][randomEmptyTile.positionX] = randomEmptyTile
        randomTile.send(randomEmptyTile)
    }
    
    func didLeftSwipeGesture() {
        guard !updatingGameBoard else { return }
        updatingGameBoard = true
        
        let nonEmptyTiles = tiles.value.flatMap({ $0 }).filter({ $0.value != 0 })
        
        for tile in nonEmptyTiles {
            
            var shiftToPositionX = tile.positionX
            let tileValue = tile.value
            
            while shiftToPositionX > 0 {
                shiftToPositionX -= 1
                
                let leftTileValue = tiles.value[tile.positionY][shiftToPositionX].value
                
                if leftTileValue > 0 && tileValue == leftTileValue {
                    tiles.value[tile.positionY][shiftToPositionX].value = leftTileValue * 2
                    // Обнуление `value` на предыдущем шаге при сдвиге плитки
                    tiles.value[tile.positionY][shiftToPositionX + 1].value = 0
                    
                    tiles.value[tile.positionY][tile.positionX].newPositionX = shiftToPositionX
                    tiles.value[tile.positionY][tile.positionX].newPositionY = tile.positionY
                    
                } else if leftTileValue > 0 && tileValue != leftTileValue {
                    // Плитка должна остаться правее той у которой `value` больше
                    tiles.value[tile.positionY][tile.positionX].newPositionX = shiftToPositionX + 1
                    tiles.value[tile.positionY][tile.positionX].newPositionY = tile.positionY
                    break
                } else {
                    tiles.value[tile.positionY][shiftToPositionX].value = tileValue
                    // Обнуление `value` на предыдущем шаге при сдвиге плитки
                    tiles.value[tile.positionY][shiftToPositionX + 1].value = 0
                    
                    tiles.value[tile.positionY][tile.positionX].newPositionX = shiftToPositionX
                    tiles.value[tile.positionY][tile.positionX].newPositionY = tile.positionY
                }
            }
        }
        addRandomTileAfterSwipe()
    }
    
    func didRightSwipeGesture() {
        guard !updatingGameBoard else { return }
        updatingGameBoard = true
        
        let nonEmptyTiles = tiles.value.flatMap({ $0 }).filter({ $0.value != 0 }).reversed()
        
        for tile in nonEmptyTiles {
            var shiftToPositionX = tile.positionX
            let tileValue = tile.value
            
            while shiftToPositionX < gameboardSize - 1 {
                shiftToPositionX += 1
                
                let rightTileValue = tiles.value[tile.positionY][shiftToPositionX].value
                
                if rightTileValue > 0 && tileValue == rightTileValue {
                    tiles.value[tile.positionY][shiftToPositionX].value = rightTileValue * 2
                    // Обнуление `value` на предыдущем шаге при сдвиге плитки
                    tiles.value[tile.positionY][shiftToPositionX - 1].value = 0
                    
                    tiles.value[tile.positionY][tile.positionX].newPositionX = shiftToPositionX
                    tiles.value[tile.positionY][tile.positionX].newPositionY = tile.positionY
                    
                } else if rightTileValue > 0 && tileValue != rightTileValue {
                    // Плитка должна остаться левее той у которой value больше
                    tiles.value[tile.positionY][tile.positionX].newPositionX = shiftToPositionX - 1
                    tiles.value[tile.positionY][tile.positionX].newPositionY = tile.positionY
                    break
                } else {
                    tiles.value[tile.positionY][shiftToPositionX].value = tileValue
                    // Обнуление `value` на предыдущем шаге при сдвиге плитки
                    tiles.value[tile.positionY][shiftToPositionX - 1].value = 0
                    
                    tiles.value[tile.positionY][tile.positionX].newPositionX = shiftToPositionX
                    tiles.value[tile.positionY][tile.positionX].newPositionY = tile.positionY
                }
            }
        }
        addRandomTileAfterSwipe()
    }
    
    
    func didUpSwipeGesture() {
        guard !updatingGameBoard else { return }
        updatingGameBoard = true
        
        let nonEmptyTiles = tiles.value.flatMap({ $0 }).filter({ $0.value != 0 })
        
        for tile in nonEmptyTiles {
            var shiftToPositionY = tile.positionY
            let tileValue = tile.value
            
            while shiftToPositionY > 0 {
                shiftToPositionY -= 1
                
                let topTileValue = tiles.value[shiftToPositionY][tile.positionX].value
                
                if topTileValue > 0 && tileValue == topTileValue {
                    tiles.value[shiftToPositionY][tile.positionX].value = topTileValue * 2
                    // Обнуление `value` на предыдущем шаге при сдвиге плитки
                    tiles.value[shiftToPositionY + 1][tile.positionX].value = 0
                    
                    tiles.value[tile.positionY][tile.positionX].newPositionX = tile.positionX
                    tiles.value[tile.positionY][tile.positionX].newPositionY = shiftToPositionY
                    
                } else if topTileValue > 0 && tileValue != topTileValue {
                    // Плитка должна остаться ниже той у которой value больше
                    tiles.value[tile.positionY][tile.positionX].newPositionX = tile.positionX
                    tiles.value[tile.positionY][tile.positionX].newPositionY = shiftToPositionY + 1
                    break
                } else {
                    tiles.value[shiftToPositionY][tile.positionX].value = tileValue
                    // Обнуление `value` на предыдущем шаге при сдвиге плитки
                    tiles.value[shiftToPositionY + 1][tile.positionX].value = 0
                    
                    tiles.value[tile.positionY][tile.positionX].newPositionX = tile.positionX
                    tiles.value[tile.positionY][tile.positionX].newPositionY = shiftToPositionY
                    
                }
            }
        }
        addRandomTileAfterSwipe()
    }
    
    func didDownSwipeGesture() {
        guard !updatingGameBoard else { return }
        updatingGameBoard = true
        
        let nonEmptyTiles = tiles.value.flatMap({ $0 }).filter({ $0.value != 0 }).reversed()
        
        for tile in nonEmptyTiles {
            var shiftToPositionY = tile.positionY
            let tileValue = tile.value
            
            while shiftToPositionY < gameboardSize - 1 {
                shiftToPositionY += 1
                
                let bottomTileValue = tiles.value[shiftToPositionY][tile.positionX].value
                
                if bottomTileValue > 0 && tileValue == bottomTileValue {
                    
                    tiles.value[shiftToPositionY][tile.positionX].value = bottomTileValue * 2
                    // Обнуление `value` на предыдущем шаге при сдвиге плитки
                    tiles.value[shiftToPositionY - 1][tile.positionX].value = 0
                    
                    tiles.value[tile.positionY][tile.positionX].newPositionX = tile.positionX
                    tiles.value[tile.positionY][tile.positionX].newPositionY = shiftToPositionY
                    
                } else if bottomTileValue > 0 && tileValue != bottomTileValue {
                    // Плитка должна остаться выше той у которой value больше
                    tiles.value[tile.positionY][tile.positionX].newPositionX = tile.positionX
                    tiles.value[tile.positionY][tile.positionX].newPositionY = shiftToPositionY - 1
                    break
                } else {
                    tiles.value[shiftToPositionY][tile.positionX].value = tileValue
                    // Обнуление `value` на предыдущем шаге при сдвиге плитки
                    tiles.value[shiftToPositionY - 1][tile.positionX].value = 0
                    
                    tiles.value[tile.positionY][tile.positionX].newPositionX = tile.positionX
                    tiles.value[tile.positionY][tile.positionX].newPositionY = shiftToPositionY
                }
            }
        }
        addRandomTileAfterSwipe()
    }
    
    
    func didTapRestartButton() {
        setupEmptyGameboard()
        coreDataManager.deleteNoteFromCoreData()
    }
    
    // MARK: - Private Methods
    private func addRandomTileAfterSwipe() {
        DispatchQueue.main.async {
            // Добавление рандомной плитки должно быть в самом конце очереди, после смещения всех остальных плиток
            self.setRandomTile()
            // После всех перемещений обнуляем (т.е. -1) новые позиции, чтобы небыло ложных перемещений
            self.tiles.value.forEach({ $0.forEach({ $0.newPositionY = -1; $0.newPositionX = -1 })})
            
            self.updatingGameBoard = false
        }
    }
    
    private func setupEmptyGameboard() {
        tiles.value = .init()
        for row in 0..<gameboardSize {
            var tileRows = [Tile]()
            for column in 0..<gameboardSize {
                
                let tile = Tile(context: coreDataManager.viewContext)
                tile.id = UUID()
                tile.value = 0
                tile.positionX = column
                tile.positionY = row
                tile.newPositionX = -1
                tile.newPositionY = -1
                
                tileRows.append(tile)
            }
            tiles.value.append(tileRows)
        }
    }
    
    private func fetchTilesFromCoreData() {
        let savedTiles = coreDataManager.fetchSavedTiles()
        
        if savedTiles.count == 0 {
            setupEmptyGameboard()
        } else {
            tiles.value = .init()
            
            for row in 0..<gameboardSize {
                var tileRows = [Tile]()
                
                for column in 0..<gameboardSize {
                    let index = row * gameboardSize + column
                    let savedTile = savedTiles[index]
                    
                    tileRows.append(savedTile)
                }
                tiles.value.append(tileRows)
            }
            coreDataManager.saveContext()
        }
    }
}
