//
//  ScratchCodeView.swift
//  ScratchCards
//
//  Created by Marek Baláž on 07/05/2023.
//

import Foundation
import UIKit
import Combine

class ScratchCodeView: UIView {
    
    // MARK: - Outlets
    
    @IBOutlet weak var componentContentView: UIView!
    
    @IBOutlet weak var backtapeView: UIView!
    @IBOutlet weak var codeLbl: UILabel!
    @IBOutlet weak var tapeProgressView: UIProgressView!
    
    // MARK: - Variables
    
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
        Bundle.main.loadNibNamed("ScratchCodeView", owner: self, options: nil)
        
        backtapeView.layer.cornerRadius = Design.defaultCornerRadius
        backtapeView.backgroundColor = UIColor.content()

        tapeProgressView.progress = 1
        tapeProgressView.layer.cornerRadius = Design.defaultCornerRadius
        tapeProgressView.layer.sublayers?[1].cornerRadius = Design.defaultCornerRadius
        tapeProgressView.subviews[1].clipsToBounds = true
        tapeProgressView.transform = CGAffineTransform(rotationAngle: .pi)
        tapeProgressView.clipsToBounds = true
        tapeProgressView.trackTintColor = UIColor.clear
        tapeProgressView.progressTintColor = UIColor.content2()
        
        codeLbl.textColor = UIColor.primary()
        codeLbl.font = UIFont.label()
        
        return componentContentView
    }

}
