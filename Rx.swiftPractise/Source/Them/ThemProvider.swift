//
//  ThemProvider.swift
//  Rx.swiftPractise
//
//  Created by 白海瑞 on 2018/8/10.
//  Copyright © 2018年 Rx.Swift. All rights reserved.
//

import Foundation
import UIKit
final class AppThemeProvider: ThemeProvider {
    static let shared: AppThemeProvider = .init()
    
    private var theme: SubscribableValue<AppThemes>
    private var availableThemes: [AppThemes] = [.light, .dark]
    
    var currentTheme: AppThemes {
        get {
            return theme.value
        }
        set {
            setNewTheme(newValue)
        }
    }
    
    init() {
        theme = SubscribableValue<AppThemes>(value: .light)
    }
    
    private func setNewTheme(_ newTheme: AppThemes) {
        let window = UIApplication.shared.delegate!.window!!
        UIView.transition(
            with: window,
            duration: 0.3,
            options: [.transitionCrossDissolve],
            animations: {
                self.theme.value = newTheme
        },
            completion: nil
        )
    }
    
    func subscribeToChanges(_ object: AnyObject, handler: @escaping (AppThemes) -> Void) {
        theme.subscribe(object, using: handler)
    }
}

extension Themed where Self: AnyObject {
    var themeProvider: AppThemeProvider {
        return AppThemeProvider.shared
    }
}

struct Weak<Object: AnyObject> {
    weak var value: Object?
}

struct SubscribableValue<T> {
    private typealias Subscription = (object: Weak<AnyObject>, handler: (T) -> Void)
    
    private var subscriptions: [Subscription] = []
    
    var value: T {
        didSet {
            for (object, handler) in subscriptions where object.value != nil {
                handler(value)
            }
        }
    }
    
    init(value: T) {
        self.value = value
    }
    
    mutating func subscribe(_ object: AnyObject, using handler: @escaping (T) -> Void) {
        subscriptions.append((Weak(value: object), handler))
        cleanupSubscriptions()
    }
    
    private mutating func cleanupSubscriptions() {
        subscriptions = subscriptions.filter({ entry in
            return entry.object.value != nil
        })
    }
}
