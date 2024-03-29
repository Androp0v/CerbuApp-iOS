//
//  CardView.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 07/08/2019.
//  Copyright © 2019 Raúl Montón Pinillos. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animate(isHighlighted: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animate(isHighlighted: false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animate(isHighlighted: false)
    }
    
    func animate(isHighlighted: Bool, completion: ((Bool) -> Void)? = nil) {
        
        if isHighlighted {
            UIView.animate(withDuration: 0.25,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: [.allowUserInteraction],
                           animations: {
                            self.transform = .init(scaleX: 0.97, y: 0.97)
            }, completion: completion)
        } else {
            UIView.animate(withDuration: 0.25,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: [.allowUserInteraction],
                           animations: {
                            self.transform = .identity
            }, completion: completion)
        }
    }

}
