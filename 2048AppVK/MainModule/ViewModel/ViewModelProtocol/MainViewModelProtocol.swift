//
//  MainViewModelProtocol.swift
//  2048AppVK
//
//  Created by Rafis on 04.04.2024.
//

import Foundation
import Combine

protocol MainViewModelProtocol {
    
    var gameboardSize: Int { get }
    var gameScore: Int { get }
    
    var tiles: CurrentValueSubject<[[Tile]], Never> { get }
    var randomTile: CurrentValueSubject<Tile?, Never> { get }
    
    func setRandomTile()
    
    func didLeftSwipeGesture()
    func didRightSwipeGesture()
    func didUpSwipeGesture()
    func didDownSwipeGesture()
    
    func didTapRestartButton()
}
