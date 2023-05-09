//
//  ViewModelContainer.swift
//  ScratchCards
//
//  Created by Marek Baláž on 07/05/2023.
//

import Foundation

protocol ViewModelContainer {
    associatedtype ViewModel: ViewModelType
    
    var viewModel: ViewModel! { get }
    
    func bind()
}
