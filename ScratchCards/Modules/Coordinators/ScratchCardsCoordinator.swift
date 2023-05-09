//
//  ScratchCardCoordinator.swift
//  ScratchCards
//
//  Created by Marek Baláž on 08/05/2023.
//

import Foundation
import UIKit

class ScratchCardsCoordinator: NSObject, Coordinator {
    
    var rootViewController: UINavigationController
    
    override init() {
        
        let navBarAppearance = UINavigationBarAppearance()
        let attributes: [NSAttributedString.Key : Any] = [.font: UIFont.text(), .foregroundColor : UIColor.primary()]
        navBarAppearance.titleTextAttributes = attributes
        navBarAppearance.largeTitleTextAttributes = [.font : UIFont.h1(), .foregroundColor : UIColor.primary()]
        navBarAppearance.buttonAppearance.normal.titleTextAttributes = attributes
        navBarAppearance.configureWithTransparentBackground()
        
        rootViewController = UINavigationController()
        rootViewController.navigationBar.prefersLargeTitles = false
        rootViewController.navigationBar.layoutMargins.left = 32
        rootViewController.navigationBar.scrollEdgeAppearance = navBarAppearance
        rootViewController.navigationBar.standardAppearance = navBarAppearance
        
        super.init()
    }
    
    func start() {
        showScratchCards()
    }
    
    func showScratchCards() {
        let viewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()
        guard let scratchCardsController = viewController as? ScratchCardsController else { return }

        scratchCardsController.coordinator = self
        scratchCardsController.viewModel = ScratchCardsViewModel(scratchCardGeneratorService: ScratchCardGeneratorService())
        scratchCardsController.title = NSLocalizedString("scratch_cards_title", comment: "")
        
        rootViewController.setViewControllers([scratchCardsController], animated: false)
    }
    
    func showRevelation(scratchCard: ScratchCardViewModel) {
        let viewController = UIStoryboard.init(name: "Revelation", bundle: nil).instantiateInitialViewController()
        guard let revelationController = viewController as? RevelationController else { return }

        revelationController.viewModel = RevelationViewModel(scratchCardViewModel: scratchCard)
  
        rootViewController.pushViewController(revelationController, animated: true)
    }
    
    func showActivation(scratchCard: ScratchCardViewModel) {
        let viewController = UIStoryboard.init(name: "Activation", bundle: nil).instantiateInitialViewController()
        guard let activationController = viewController as? ActivationController else { return }

        activationController.viewModel = ActivationViewModel(scratchCardViewModel: scratchCard, activationService: ActivationService(networkService: NetworkService()))

        rootViewController.pushViewController(activationController, animated: true)
    }
    
}
