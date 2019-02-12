//
//  ViewController.swift
//  PlayingCard
//
//  Created by Sara Elsayed Salem on 12/26/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var deck = PlayingCardDeck()
    
    @IBOutlet var cardViews: [PlayingCardView]!
    
    lazy var animator = UIDynamicAnimator(referenceView: view)
    lazy var cardBehavior = CardBehavior(in: animator)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var cards = [PlayingCard]()
        for _ in 1...(cardViews.count+1)/2 { // to get 12 repeated random cards
            let card = deck.draw()!
            cards += [card,card]
        }
        
        for cardview in cardViews {
            
            let card = cards.remove(at: cards.count.arc4random)
            cardview.isFaceUp = false
            cardview.rank = card.rank.order
            cardview.suit = card.suit.rawValue
            cardview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:)))) //self vc
            cardBehavior.addItem(cardview)
        }
    }
    
    var lastChosenCardView:PlayingCardView?
    var faceUpCardViews:[PlayingCardView]{                       // and not matched in scale bigger img //
        return cardViews.filter{$0.isFaceUp && !$0.isHidden &&  $0.transform != CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0) && $0.alpha == 1 }
    }
    var faceUpCardViewsMatch : Bool {
        return faceUpCardViews.count == 2 && faceUpCardViews[0].rank == faceUpCardViews[1].rank && faceUpCardViews[0].suit == faceUpCardViews[1].suit
    }
    
    @objc func flipCard(_ recognizer:UITapGestureRecognizer){
        switch recognizer.state {
        case .ended:
            if let chosenView =  recognizer.view as? PlayingCardView ,faceUpCardViews.count<2 {
                lastChosenCardView = chosenView
                
                cardBehavior.removeItem(chosenView) //to stop moving it
                UIView.transition(with: chosenView,
                                  duration: 0.6,
                                  options: [.transitionFlipFromLeft],
                                  animations: {
                                    chosenView.isFaceUp = !chosenView.isFaceUp
                                  },
                                  completion : { finished in
                                    let cardsToMatch = self.faceUpCardViews
                                    if self.faceUpCardViewsMatch {  //matched cards
                                        //to scale card bigger we need transform which is view property in UIViewPropertyAnimator
                                        UIViewPropertyAnimator.runningPropertyAnimator(
                                            withDuration: 0.6,
                                            delay: 0,
                                            options: [],
                                            animations: {
                                                cardsToMatch.forEach{
                                                    $0.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
                                                }
                                                
                                            },
                                            completion:{ position in
                                                UIViewPropertyAnimator.runningPropertyAnimator(
                                                    withDuration: 0.75,
                                                    delay: 0,
                                                    options: [],
                                                    animations: {
                                                        cardsToMatch.forEach{
                                                            $0.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
                                                            $0.alpha = 0
                                                        }
                                                        
                                                },completion: { position in
                                                    cardsToMatch.forEach{
                                                        $0.transform = .identity
                                                        $0.alpha = 1
                                                        $0.isHidden = true
                                                    }
                                                })
                                        })
                                    }
                                    else if cardsToMatch.count == 2 {   //not matched cards //face down
                                        if self.lastChosenCardView == chosenView { //in slow movement behaviors intersect so we mark it with second one
                                            cardsToMatch.forEach({ playingcard in
                                                UIView.transition(with: playingcard,
                                                                  duration: 0.6,
                                                                  options: [.transitionFlipFromLeft],
                                                                  animations: {
                                                                    playingcard.isFaceUp = false
                                                },completion: { finished in
                                                    self.cardBehavior.addItem(playingcard)
                                                    
                                                })
                                            })
                                        }
                                     
                                        
                                    }else{
                                        if !chosenView.isFaceUp{ //press on one
                                            self.cardBehavior.addItem(chosenView)
                                        }
                                    }
                })
                
            }
        default:
            break
        }
    }
    
}

extension CGFloat{
    var arc4random : CGFloat {
        if self > 0 {
            return CGFloat(arc4random_uniform(UInt32(self)))
        }else if self < 0 {
            return -CGFloat(arc4random_uniform(UInt32(abs(self))))
        }else{ // = zero
            return 0.0
        }
    }
}
