//
//  EmptyTileView.swift
//  2048AppVK
//
//  Created by Rafis on 06.04.2024.
//

import UIKit

final class EmptyTileView: UIView {
    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Constants
    private enum UIConstants {
        static let tileViewCornerRadius: CGFloat = 5
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = AppColor.gray
        layer.cornerRadius = UIConstants.tileViewCornerRadius
    }
}
