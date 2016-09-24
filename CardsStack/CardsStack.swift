//
//  CardsStack.swift
//  DynamicStackOfCards
//
//  Created by housing on 9/24/16.
//  Copyright © 2016 pritesh. All rights reserved.
//

import Foundation
import UIKit

public enum CardsPosition {
    case Collapsed
    case Expanded
}

public struct Configuration {
    let cardOffset: Float
    let collapsedHeight:Float
    let expandedHeight:Float
    let cardHeight: Float
    let downwardThreshold: Float
    let upwardThreshold: Float
    let verticalSpacing: Float
    let leftSpacing: Float
    let rightSpacing: Float
    
    public init(cardOffset: Float, collapsedHeight: Float, expandedHeight: Float, cardHeight: Float, downwardThreshold: Float, upwardThreshold: Float, leftSpacing: Float = 8.0, rightSpacing: Float = 8.0, verticalSpacing: Float = 8.0) {
        self.cardOffset = cardOffset
        self.collapsedHeight = collapsedHeight
        self.expandedHeight = expandedHeight
        self.downwardThreshold = downwardThreshold
        self.upwardThreshold = upwardThreshold
        self.cardHeight = cardHeight
        self.verticalSpacing = verticalSpacing
        self.leftSpacing = leftSpacing
        self.rightSpacing = rightSpacing
    }
}

@objc public protocol CardsManagerDelegate {
    
    @objc optional func tappedOnCardsStack(cardsCollectionView: UICollectionView)
    @objc optional func cardsCollectionView(_ cardsCollectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    @objc optional func cardsCollectionView(_ cardsCollectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
}

public class CardsStack {
    
    public weak var delegate: CardsManagerDelegate? = nil {
        didSet {
            cardsManager.delegate = delegate
        }
    }
    private var cardsManager = CardsManager()
    
    internal(set) var position: CardsPosition
    
   public convenience init() {
        let configuration = Configuration(cardOffset: 40, collapsedHeight: 200, expandedHeight: 500, cardHeight: 200, downwardThreshold: 20, upwardThreshold: 20)

        self.init(cardsState: .Collapsed, configuration: configuration, collectionView: nil, collectionViewHeight: nil)
    }
    
    public init(cardsState: CardsPosition, configuration: Configuration, collectionView: UICollectionView?, collectionViewHeight: NSLayoutConstraint?) {
        
        position = cardsState
        cardsManager = CardsManager(cardState: cardsState, configuration: configuration, collectionView: collectionView, heightConstraint: collectionViewHeight)
        cardsManager.cardsDelegate = self
    }
    
    public func updateView(with position: CardsPosition) {
        cardsManager.updateView(with: position)
    }
}
