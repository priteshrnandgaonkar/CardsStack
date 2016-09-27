//
//  CardStack.swift
//  DynamicStackOfCards
//
//  Created by Pritesh Nandgaonkar on 9/24/16.
//  Copyright © 2016 pritesh. All rights reserved.
//

import Foundation
import UIKit

@objc public enum CardsPosition: Int {
    case Collapsed
    case Expanded
}

public struct Configuration {
    public let cardOffset: Float
    public let collapsedHeight:Float
    public let expandedHeight:Float
    public let cardHeight: Float
    public let downwardThreshold: Float
    public let upwardThreshold: Float
    public let verticalSpacing: Float
    public let leftSpacing: Float
    public let rightSpacing: Float
    
    public init(cardOffset: Float, collapsedHeight: Float, expandedHeight: Float, cardHeight: Float, downwardThreshold: Float = 20, upwardThreshold: Float = 20, leftSpacing: Float = 8.0, rightSpacing: Float = 8.0, verticalSpacing: Float = 8.0) {
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
    
    @objc optional func cardsPositionChangedTo(position: CardsPosition)
    @objc optional func tappedOnCardsStack(cardsCollectionView: UICollectionView)
    @objc optional func cardsCollectionView(_ cardsCollectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    @objc optional func cardsCollectionView(_ cardsCollectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
}

public class CardStack {
    
    public weak var delegate: CardsManagerDelegate? = nil {
        didSet {
            cardsManager.delegate = delegate
        }
    }
    internal var cardsManager = CardsManager()
    
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
    
    public func changeCardsPosition(to position: CardsPosition) {
        cardsManager.updateView(with: position)
    }
}
