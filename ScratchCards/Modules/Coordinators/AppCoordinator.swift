//
//  AppCoordinator.swift
//  ScratchCards
//
//  Created by Marek Baláž on 08/05/2023.
//

import Foundation
import UIKit
 
class AppCoordinator: Coordinator {
    
    private var window = UIWindow(frame: UIScreen.main.bounds)
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in }
        showScratchCards()
    }
    
    func showScratchCards() {
        let scratchCardCoordinator = ScratchCardsCoordinator()
        scratchCardCoordinator.start()
        self.window.rootViewController = scratchCardCoordinator.rootViewController
    }
    
}
