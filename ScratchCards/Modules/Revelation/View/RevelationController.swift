//
//  RevelationController.swift
//  ScratchCards
//
//  Created by Marek Baláž on 09/05/2023.
//

import Foundation
import UIKit
import Combine

class RevelationController: UIViewController, ViewModelContainer {
    
    // MARK: - Outlets
    
    @IBOutlet weak var scratchCardView: ScratchCardView!
    
    // MARK: - Variables
    
    var viewModel: RevelationViewModel!
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Actions
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopRevealAnimation()
    }
    
    func bind() {
        
        scratchCardView.titleLbl.text = viewModel.scratchCardViewModel.titleText
        scratchCardView.playCodeLbl.text = viewModel.scratchCardViewModel.playCodeText
        viewModel.scratchCardViewModel.revealBtnAction = viewModel.startRevealAnimation
        
        viewModel.isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                
                switch isLoading {
                case .isLoading:
                    self.scratchCardView.standardBtnView.startLoading()
                case .isFinished:
                    let generator = UIImpactFeedbackGenerator(style: .heavy)
                    generator.impactOccurred()
                    self.scratchCardView.standardBtnView.finishLoading(true)
                case .normal:
                    self.scratchCardView.standardBtnView.finishLoading()
                case .failed:
                    self.scratchCardView.standardBtnView.failed()
                }
    
            }
            .store(in: &cancellables)
        
        viewModel.tapeProgressViewProgress
            .receive(on: RunLoop.main)
            .sink { [weak self] progress in
                guard let self = self else { return }
                
                self.scratchCardView.playCodeView.tapeProgressView.setProgress(progress, animated: true)
            }
            .store(in: &cancellables)
        
        viewModel.codeLblText
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                guard let self = self else { return }
                
                self.scratchCardView.playCodeView.codeLbl.text = text
            }
            .store(in: &cancellables)
        
        viewModel.scratchCardViewModel.$scratchCard
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                self.scratchCardView.numberLbl.text = String(self.viewModel.scratchCardViewModel.scratchCard.number)
            }
            .store(in: &cancellables)
        
        viewModel.scratchCardViewModel.$scratchCardState
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                self.scratchCardView.subtitleLbl.text = self.viewModel.scratchCardViewModel.getScratchCardStateText()
                if let playCode = self.viewModel.scratchCardViewModel.scratchCard.playCode {
                    self.scratchCardView.playCodeView.codeLbl.text = playCode
                }
            }
            .store(in: &cancellables)
        
        if let config = self.viewModel.scratchCardViewModel.getScratchCardBtn() {
            self.scratchCardView.standardBtnView.configure(config)
        }
    }
    
}
