//
//  ScratchCardCell.swift
//  ScratchCards
//
//  Created by Marek Baláž on 08/05/2023.
//

import UIKit
import Combine

class ScratchCardCell: UITableViewCell {
    
    @IBOutlet weak var scratchCardView: ScratchCardView!
    
    private var cancellables = Set<AnyCancellable>()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func set(viewModel: ScratchCardViewModel) {
        scratchCardView.titleLbl.text = viewModel.titleText
        scratchCardView.playCodeLbl.text = viewModel.playCodeText
        
        viewModel.$scratchCard.sink { [weak self] _ in
            guard let self = self else { return }
            
            self.scratchCardView.numberLbl.text = String(viewModel.scratchCard.number)
        }.store(in: &cancellables)
        
        viewModel.$scratchCardState
            .sink { [weak self] state in
                guard let self = self else { return }
                
                self.scratchCardView.subtitleLbl.text = viewModel.getScratchCardStateText()
                
                switch state {
                case .generated:
                    ()
                case .revealed, .activated:
                    self.scratchCardView.playCodeView.tapeProgressView.isHidden = true
                    self.scratchCardView.playCodeView.codeLbl.text = viewModel.scratchCard.playCode
                }
                
                if let config = viewModel.getScratchCardNavigateBtn() {
                    self.scratchCardView.standardBtnView.configure(config)
                    self.scratchCardView.bottomView.isHidden = false
                } else {
                    self.scratchCardView.bottomView.isHidden = true
                }
        }.store(in: &cancellables)
    }
    
    override func prepareForReuse() {
        scratchCardView.standardBtnView.button.removeTarget(nil, action: nil, for: .allEvents)
    }
}
