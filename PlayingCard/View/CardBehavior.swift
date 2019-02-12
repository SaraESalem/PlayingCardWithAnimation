//
//  CardBehavior.swift
//  PlayingCard
//
//  Created by Sara Elsayed Salem on 1/16/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class CardBehavior: UIDynamicBehavior {
    
    lazy var collisionBehavior : UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()
    
    lazy var itemBehavior :UIDynamicItemBehavior = { // for behavior that result from other behaviors
        let behavior = UIDynamicItemBehavior()
        behavior.elasticity = 1.0 //dont gain energy or lose energy just keep moving normal (fly) if it become 1.1 it faste
        behavior.resistance = 0
        behavior.allowsRotation = false // don't rotate
        return behavior
    }()
    
    private func push(_ item : UIDynamicItem){
        let push = UIPushBehavior(items: [item], mode: .instantaneous) //causing those items to change position accordingly.
        push.angle = (2*CGFloat.pi).arc4random
        push.magnitude = CGFloat(1.0) + CGFloat(2.0).arc4random
        push.action = { [unowned push,weak self] in
//            push.dynamicAnimator?.removeBehavior(push) //remove from animator
            self?.removeChildBehavior(push) //remove push once it happens 3l4an keda btbt2 fel a5er
        }
        addChildBehavior(push)
    }
    
    func addItem(_ item:UIDynamicItem){
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        push(item)
    }
    func removeItem(_ item:UIDynamicItem){
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
    }
    override init() {
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
    }
    
    convenience init(in animator:UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }

}
