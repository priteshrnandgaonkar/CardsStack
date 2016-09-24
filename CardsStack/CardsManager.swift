//
//  CardsManager.swift
//  DynamicStackOfCards
//
//  Created by housing on 9/24/16.
//  Copyright © 2016 pritesh. All rights reserved.
//

import Foundation
import UIKit

internal enum CardState {
    case Expanded
    case InTransit
    case Collapsed
}

internal class CardsManager: NSObject, CardLayoutDelegate {
    
    var fractionToMove:Float = 0
    var cardState: CardState {
        didSet {
            print("In did set")
            switch cardState {
            case .InTransit:
                tapGesture.isEnabled = false
                
            case .Collapsed:
                cardsDelegate?.position = .Collapsed
                tapGesture.isEnabled = true
                
            case .Expanded:
                cardsDelegate?.position = .Expanded
                tapGesture.isEnabled = false
            }
        }
    }
    var configuration: Configuration
    
    weak var delegate: CardsManagerDelegate?
    weak var collectionView: UICollectionView?
    weak var cardsCollectionViewHeight: NSLayoutConstraint?
    weak var cardsDelegate: CardsStack? = nil

    var panGesture = UIPanGestureRecognizer()
    var tapGesture = UITapGestureRecognizer()
    
    var previousTranslation: CGFloat = 0

    convenience override init() {
        
        let configuration = Configuration(cardOffset: 40, collapsedHeight: 200, expandedHeight: 500, cardHeight: 200, downwardThreshold: 20, upwardThreshold: 20)
        
        self.init(cardState: .Collapsed, configuration: configuration, collectionView: nil, heightConstraint: nil)
    }
    
    func cardsStateFromCardsPosition(position: CardsPosition) -> CardState {
        switch position {
        case .Expanded:
            return CardState.Expanded
        case .Collapsed:
            return CardState.Collapsed
        }
    }
    
    init(cardState: CardsPosition, configuration: Configuration, collectionView: UICollectionView?, heightConstraint: NSLayoutConstraint?) {
        
        switch cardState {
        case .Expanded:
            self.cardState = CardState.Expanded
        case .Collapsed:
            self.cardState = CardState.Collapsed
        }

        self.configuration = configuration
        cardsCollectionViewHeight = heightConstraint
        self.collectionView = collectionView
        super.init()
        guard let cardsView = self.collectionView else {
            return
        }
        cardsView.delegate = self
        if let cardLayout = cardsView.collectionViewLayout as? CardLayout {
            cardLayout.delegate = self
        }
        panGesture = UIPanGestureRecognizer(target: self, action:#selector(self.pannedCard))
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tappedCard))
        cardsView.addGestureRecognizer(panGesture)
        cardsView.addGestureRecognizer(tapGesture)
        panGesture.isEnabled = cardState == .Collapsed
        tapGesture.isEnabled = cardState == .Collapsed
    }
    
    func tappedCard(tapGesture: UITapGestureRecognizer) {
        print("Tapped")
        guard let cardsCollectionView = collectionView else {
            return
        }
        delegate?.tappedOnCardsStack?(cardsCollectionView: cardsCollectionView)
    }
    
    func pannedCard(panGesture: UIPanGestureRecognizer) {
        guard let collectionView = self.collectionView else {
            return
        }
        let translation = panGesture.translation(in: collectionView.superview!)
        collectionView.collectionViewLayout.invalidateLayout()
        
        let distanceMoved = translation.y
            guard let heightConstraint = self.cardsCollectionViewHeight else {
                return
            }
            
            switch panGesture.state {
            case .changed:
                heightConstraint.constant -= distanceMoved
                
                heightConstraint.constant = Swift.min(heightConstraint.constant, CGFloat(self.configuration.expandedHeight))
                heightConstraint.constant = Swift.max(heightConstraint.constant, CGFloat(self.configuration.collapsedHeight))
                
                self.cardState = .InTransit
                self.fractionToMove = Float(heightConstraint.constant - CGFloat(self.configuration.collapsedHeight))
                self.collectionView?.isScrollEnabled = false
                
                
                self.collectionView?.performBatchUpdates({
                    self.collectionView?.collectionViewLayout.invalidateLayout()
                    self.collectionView?.superview?.layoutIfNeeded()
                    
                    }, completion: nil)
                
            case .cancelled:
                fallthrough
            case .ended:
                
                if self.previousTranslation < 0 {
                    if heightConstraint.constant > CGFloat(self.configuration.collapsedHeight + self.configuration.upwardThreshold) {
                        heightConstraint.constant = CGFloat(self.configuration.expandedHeight)
                        self.cardState = .Expanded
                        self.panGesture.isEnabled = false
                    }
                    else {
                        heightConstraint.constant = CGFloat(self.configuration.collapsedHeight)
                        self.cardState = .Collapsed
                        self.panGesture.isEnabled = true
                    }
                }
                else {
                    if heightConstraint.constant < CGFloat(self.configuration.expandedHeight - self.configuration.downwardThreshold) {
                        heightConstraint.constant = CGFloat(self.configuration.collapsedHeight)
                        self.cardState = .Collapsed
                        self.panGesture.isEnabled = true
                    }
                    else {
                        
                        heightConstraint.constant = CGFloat(self.configuration.expandedHeight)
                        self.cardState = .Expanded
                        self.panGesture.isEnabled = false
                    }
                    
                }
                self.collectionView?.isScrollEnabled = !panGesture.isEnabled
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.collectionView?.collectionViewLayout.invalidateLayout()
                    self.collectionView?.superview?.layoutIfNeeded()
                })
    
            default:
                break
            }
            
            self.previousTranslation = translation.y
            self.panGesture.setTranslation(CGPoint.zero, in: self.collectionView?.superview)
        }
    
    
    
    func updateView(with position: CardsPosition) {
        var ht:Float = 0.0
        cardState = cardsStateFromCardsPosition(position: position)
        switch cardState {
        case .Collapsed:
            ht = configuration.collapsedHeight
            
        case .Expanded:
            ht = configuration.expandedHeight
        default:
            print("Returned")
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            
            guard let weakSelf = self else {
                return
            }
            weakSelf.cardsCollectionViewHeight?.constant = CGFloat(ht)
            
            UIView.animate(withDuration: 0.3, animations: {
                weakSelf.collectionView?.collectionViewLayout.invalidateLayout()
                weakSelf.collectionView?.superview?.layoutIfNeeded()
            })
        }
    }
}

extension CardsManager: UICollectionViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {

            if scrollView.contentOffset.y < -10 {
                panGesture.isEnabled = true
                scrollView.isScrollEnabled = false
            }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.cardsCollectionView?(collectionView, didSelectItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        delegate?.cardsCollectionView?(collectionView, willDisplay: cell, forItemAt: indexPath)
    }
}
