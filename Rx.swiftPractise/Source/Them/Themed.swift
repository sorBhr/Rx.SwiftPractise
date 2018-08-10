//
//  Themed.swift
//  Rx.swiftPractise
//
//  Created by 白海瑞 on 2018/8/10.
//  Copyright © 2018年 Rx.Swift. All rights reserved.
//

import Foundation
import UIKit


struct AppThemes {
    var statusBarStyle: UIStatusBarStyle
    var barBackgroundColor: UIColor
    var barForegroundColor: UIColor
    var backgroundColor: UIColor
    var textColor: UIColor
}


//MARK: protocol
protocol ThemeProvider {
    
    associatedtype Theme
    
    var currentTheme: Theme { get }
    
    func subscribeToChanges(_ object: AnyObject, handler: @escaping (Theme) -> Void)
}

protocol Themed {
    associatedtype _ThemeProvider: ThemeProvider
    
    var themeProvider: _ThemeProvider { get }
    
    func applyTheme(_ theme: _ThemeProvider.Theme)
}


//MARK: extension
extension AppThemes {
    static let light = AppThemes(
        statusBarStyle: .`default`,
        barBackgroundColor: .white,
        barForegroundColor: .black,
        backgroundColor: UIColor(white: 0.9, alpha: 1),
        textColor: .darkText
    )
    
    static let dark = AppThemes(
        statusBarStyle: .lightContent,
        barBackgroundColor: UIColor(white: 0, alpha: 1),
        barForegroundColor: .white,
        backgroundColor: UIColor(white: 0.2, alpha: 1),
        textColor: .lightText
    )
}

extension Themed where Self: AnyObject {
    
    func initTheme() {
        applyTheme(themeProvider.currentTheme)
        themeProvider.subscribeToChanges(self) { [weak self] newTheme in
            self?.applyTheme(newTheme)
        }
    }
}
