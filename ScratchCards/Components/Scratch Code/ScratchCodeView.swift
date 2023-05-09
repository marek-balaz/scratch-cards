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
    
//    private var scrambleTimer: AnyCancellable?
//    private var tapeProgressTimer: AnyCancellable?
//    private var tapeProgressDuration: Float!
    
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
        
//        startScrambleTextAnimation(generateScrambledUUID)
//        startRevealAnimation(duration: 2)
        
        return componentContentView
    }
    
    // MARK: - Setup
    
//    func startScrambleTextAnimation(_ action: @escaping (() -> String)) {
//        scrambleTimer = Timer.publish(every: 0.05, on: .main, in: .common)
//            .autoconnect()
//            .map({ _ in action() })
//            .assign(to: \.text, on: codeLbl)
//    }
//
//    func stopScrambleTextAnimation() {
//        scrambleTimer?.cancel()
//    }
//
//    func startRevealAnimation(duration: Float) {
//        tapeProgressDuration = duration
//        tapeProgressTimer = Timer.publish(every: 0.01, on: .main, in: .common)
//            .autoconnect()
//            .sink { _ in
//                if self.tapeProgressDuration == 0 {
//                    self.tapeProgressView.setProgress(0, animated: true)
//                    self.tapeProgressTimer?.cancel()
//                } else {
//                    self.tapeProgressView.setProgress((self.tapeProgressDuration / duration), animated: true)
//                    self.tapeProgressDuration -= 0.01
//                }
//            }
//    }
//
//    func stopRevealAnimation() {
//        tapeProgressTimer?.cancel()
//        tapeProgressView.setProgress(1, animated: true)
//    }
}
