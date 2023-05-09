//
//  ScratchCardsController.swift
//  ScratchCards
//
//  Created by Marek Baláž on 07/05/2023.
//

import UIKit
import Combine

class ScratchCardsController: UIViewController, ViewModelContainer {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableScratchCards: UITableView!
    
    // MARK: - Variables
    
    var viewModel: ScratchCardsViewModel!
    var coordinator: ScratchCardsCoordinator!
    private var cancellables = Set<AnyCancellable>()
    
    private let scratchCardReuseId = "ScratchCardCell"
    
    // MARK: - Actions
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableScratchCards.delegate = self
        tableScratchCards.dataSource = self
        tableScratchCards.register(UINib(nibName: scratchCardReuseId, bundle: nil), forCellReuseIdentifier: scratchCardReuseId)
        tableScratchCards.translatesAutoresizingMaskIntoConstraints = false
        bind()
    }
    
    func bind() {
        
        viewModel.$scratchCards
            .map { scratchCards -> [ScratchCardViewModel] in
                return scratchCards.map { ScratchCardViewModel(scratchCard: $0) }
            }
            .sink(receiveValue: { [weak self] scratchCardViewModels in
                guard let self = self else { return }
                self.viewModel.cellViewModels = scratchCardViewModels
            })
            .store(in: &cancellables)

        viewModel.cellViewModels.forEach { cellViewModel in
                    cellViewModel.scratchCardUpdated
                        .receive(on: RunLoop.main)
                        .sink { [weak self] scratchCard in
                            guard let index = self?.viewModel.scratchCards.firstIndex(where: { $0.number == scratchCard.number })
                            else {
                                return
                            }
                            let indexPath = IndexPath(row: index, section: 0)
                            self?.tableScratchCards.reloadRows(at: [indexPath], with: .none)
                        }
                        .store(in: &cancellables)
                }
    }
    
    // MARK: - Implementation
    
}

extension ScratchCardsController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.scratchCards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: scratchCardReuseId, for: indexPath) as! ScratchCardCell
        let cellViewModel = viewModel.cellViewModels[indexPath.row]
        cellViewModel.revealBtnNavigateAction = { [weak self] in
            self?.coordinator.showRevelation(scratchCard: cellViewModel)
        }
        cellViewModel.activateBtnNavigateAction = { [weak self] in
            self?.coordinator.showActivation(scratchCard: cellViewModel)
        }
        cell.set(viewModel: cellViewModel)
        
        return cell
    }
    
}


