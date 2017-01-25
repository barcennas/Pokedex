//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Abraham Barcenas M on 1/21/17.
//  Copyright © 2017 barcennas. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var mainImage: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var defenceLabel: UILabel!
    @IBOutlet var heightLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var pokedexIdLabel: UILabel!
    @IBOutlet var attackLabel: UILabel!
    @IBOutlet var evolutionLabel: UILabel!
    @IBOutlet var currentEvolutionImage: UIImageView!
    @IBOutlet var nextEvolutionImage: UIImageView!
    @IBOutlet var segment: UISegmentedControl!
    
    
    var pokemon : Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = pokemon.name.capitalized
        mainImage.image = UIImage(named: "\(pokemon.pokedexId)")
        pokedexIdLabel.text = "\(pokemon.pokedexId)"
        currentEvolutionImage.image = UIImage(named: "\(pokemon.pokedexId)")
        
        pokemon.downloadPokemonDetail { 
            //execute after network call is complete
            self.updateUI()
        }
        
    }

    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateUI(){
        
        descriptionLabel.text = pokemon.description
        typeLabel.text = pokemon.type
        defenceLabel.text = pokemon.defence
        heightLabel.text = pokemon.height
        weightLabel.text = pokemon.weight
        attackLabel.text = pokemon.attack
        
        if pokemon.nextEvolutionId == "" {
            evolutionLabel.text = "No Evolutions"
            nextEvolutionImage.isHidden = true
        }else{
            nextEvolutionImage.isHidden = false
            nextEvolutionImage.image = UIImage(named: "\(pokemon.nextEvolutionId)")
            evolutionLabel.text = "Next Evolutions: \(pokemon.nextEvolutionName) - LVL \(pokemon.nextEvolutionLvl)"
            
        }
        
        
    }

}
