//
//  StandardButton.swift
//  Urbi
//
//  Created by Marek Baláž on 23/05/2022.
//  Copyright © 2022 Elmolis. All rights reserved.
//

import UIKit

enum StandardButtonStyle {
    case primaryActive
    case primaryDisabled
    case secondaryActive
    case secondaryDisabled
}

enum StandarbButtonState {
    case isLoading
    case isFinished
    case normal
    case failed
}

class StandardButtonView: UIView {
    
    // MARK: - Outlets
    
    @IBOutlet weak var componentContentView: UIView!

    @IBOutlet weak var titleLbl     : UILabel!
    @IBOutlet weak var button       : UIButton!
    @IBOutlet weak var iconRight    : UIImageView!
    @IBOutlet weak var view         : UIView!
    @IBOutlet weak var loadingView  : UIView!
    @IBOutlet weak var loadingIcon  : UIImageView!

    @IBOutlet weak var widthCons    : NSLayoutConstraint!
    
    // MARK: - Variables
    
    private var type: StandardButtonStyle = .primaryActive {
        didSet {
            setupView()
        }
    }
    private var tempTitle: String!
    
    // MARK: - Constants
    
    public let HEIGHT: CGFloat = 50
    
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
        Bundle.main.loadNibNamed("StandardButtonView", owner: self, options: nil)
        setupView()
        
        view.layer.cornerRadius = Design.defaultCornerRadius
        view.layer.shadowColor = UIColor.primary().cgColor
        view.layer.shadowOpacity = 0.24
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = Design.defaultCornerRadius
        
        loadingView.isHidden = true
        titleLbl.font = UIFont.label()
        view.layer.cornerRadius = Design.defaultCornerRadius
        
        return componentContentView
    }
    
    // MARK: - Setup
    
    func configure(_ config: (type: StandardButtonStyle, title: String, action: (() -> Void), hasImage: Bool)) {
        titleLbl.text = config.title
        button.addAction(UIAction(handler: { _ in config.action() }), for: .touchUpInside)
        self.type = config.type
        iconRight.isHidden = !config.hasImage
    }
    
    // MARK: - Style
    
    func setupView() {
        
        switch type {
        case .primaryActive:
            setAppearance(backgroundColor: UIColor.primary(),
                          borderColor: UIColor.primary(),
                          borderWidth: 0,
                          titleColor: UIColor.background2(),
                          userInteraction: true,
                          loadingColor: UIColor.background2(),
                          shadowOpacity: 0.24)
        case .primaryDisabled:
            setAppearance(backgroundColor: UIColor.primary().withAlphaComponent(0.4),
                          borderColor: UIColor.primary().withAlphaComponent(0.4),
                          borderWidth: 0,
                          titleColor: UIColor.background2(),
                          userInteraction: false,
                          loadingColor: UIColor.background2(),
                          shadowOpacity: 0.0)
        case .secondaryActive:
            setAppearance(backgroundColor: UIColor.clear,
                          borderColor: UIColor.primary(),
                          borderWidth: 1,
                          titleColor: UIColor.primary(),
                          userInteraction: true,
                          loadingColor: UIColor.primary(),
                          shadowOpacity: 0.0)
        case .secondaryDisabled:
            setAppearance(backgroundColor: UIColor.clear,
                          borderColor: UIColor.primary().withAlphaComponent(0.4),
                          borderWidth: 1,
                          titleColor: UIColor.primary().withAlphaComponent(0.4),
                          userInteraction: false,
                          loadingColor: UIColor.primary().withAlphaComponent(0.4),
                          shadowOpacity: 0.0)
        }
    }
        
    func setAppearance(backgroundColor: UIColor, borderColor: UIColor, borderWidth: CGFloat, titleColor: UIColor, userInteraction: Bool, loadingColor: UIColor, shadowOpacity: Float) {
        self.view.backgroundColor = backgroundColor
        self.view.layer.borderColor = borderColor.cgColor
        self.view.layer.borderWidth = borderWidth
        self.titleLbl.textColor = titleColor
        self.iconRight.tintColor = titleColor
        self.loadingIcon.tintColor = titleColor
        self.button.isUserInteractionEnabled = userInteraction
        self.view.layer.shadowOpacity = shadowOpacity
    }
    
    func startLoading() {
        button.isUserInteractionEnabled = false
        loadingView.isHidden = false
        self.tempTitle = self.titleLbl.text
        UIView.animate(withDuration: Animation.TIME) {
            self.titleLbl.text = ""
            self.layoutIfNeeded()
        }
        loadingView.rotate360Degrees()
    }
    
    func finishLoading(_ success: Bool = false) {
        button.isUserInteractionEnabled = true
        loadingView.layer.removeAllAnimations()
        if success {
            button.isUserInteractionEnabled = false
            UIView.animate(withDuration: Animation.TIME) {
                self.loadingIcon.image = UIImage(named: "check-mark")
                self.layoutIfNeeded()
            }
        } else {
            if loadingView.isHidden == false {
                loadingView.isHidden = true
                self.titleLbl.text = self.tempTitle
                self.layoutIfNeeded()
            }
        }
    }
    
    func failed() {
        loadingView.layer.removeAllAnimations()
        button.isUserInteractionEnabled = false
        UIView.animate(withDuration: Animation.TIME) {
            self.loadingIcon.image = UIImage(named: "cross")
            self.layoutIfNeeded()
        }
    }

}
