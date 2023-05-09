//
//  ScratchCardView.swift
//  ScratchCards
//
//  Created by Marek Baláž on 07/05/2023.
//

import Foundation
import UIKit

enum ScratchCardViewType {
    case generated
    case revealed
    case activated
}

class ScratchCardView: UIView {
    
    // MARK: - Outlets
    
    @IBOutlet weak var componentContentView: UIView!
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var numberView: UIView!
    @IBOutlet weak var numberLbl: UILabel!
    
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var playCodeLbl: UILabel!
    @IBOutlet weak var playCodeView: ScratchCodeView!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var standardBtnView: StandardButtonView!
    
    // MARK: - Variables
    
    var type: ScratchCardViewType?
    
    // MARK: - Overrides
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupXib()
    }
    
    private func setupXib() {
        let view = loadXib()
        view?.frame = self.bounds
        view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(componentContentView)
        componentContentView = view
    }
    
    private func loadXib() -> UIView? {
        Bundle.main.loadNibNamed("ScratchCardView", owner: self, options: nil)
        
        shadowView.layer.cornerRadius = Design.defaultCornerRadius
        shadowView.layer.shadowColor = UIColor.content().cgColor
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 4)
        shadowView.layer.shadowRadius = Design.defaultCornerRadius
        
        cardView.clipsToBounds = true
        cardView.layer.cornerRadius = Design.defaultCornerRadius
        cardView.backgroundColor = UIColor.background2()
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor.content().cgColor
        
        topView.backgroundColor = UIColor.background2()
        middleView.backgroundColor = UIColor.background2()
        bottomView.backgroundColor = UIColor.background2()
        
        numberView.backgroundColor = UIColor.content()
        numberView.layer.cornerRadius = 12
        numberView.layer.borderWidth = 1
        numberView.layer.borderColor = UIColor.content2().cgColor
        
        titleLbl.font = UIFont.textAttention()
        subtitleLbl.font = UIFont.text()
        numberLbl.font = UIFont.textAttention()
        playCodeLbl.font = UIFont.textAttention()
        
        titleLbl.textColor = UIColor.primary()
        subtitleLbl.textColor = UIColor.primary()
        numberLbl.textColor = UIColor.primary()
        playCodeLbl.textColor = UIColor.primary()
        
        return componentContentView
    }

}
