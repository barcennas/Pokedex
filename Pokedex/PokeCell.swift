//
//  PokeCell.swift
//  Pokedex
//
//  Created by Abraham Barcenas M on 1/19/17.
//  Copyright © 2017 barcennas. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet var thumbImg : UIImageView!
    @IBOutlet var nameLabel : UILabel!
    
    var pokemon : Pokemon!
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5
    }
    
    func configureCell (pokemon: Pokemon){
        self.pokemon = pokemon
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
        nameLabel.text = self.pokemon.name.capitalized
    }
    
    
}
