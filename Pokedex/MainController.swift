//
//  MainController.swift
//  Pokedex
//
//  Created by Abraham Barcenas M on 1/19/17.
//  Copyright © 2017 barcennas. All rights reserved.
//

import UIKit
import AVFoundation

class MainController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet var collection : UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    
    var pokemons : [Pokemon] = []
    var filterPokemons : [Pokemon] = []
    var audioPlayer : AVAudioPlayer!
    var inSearchMode : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        collection.delegate = self
        collection.dataSource = self
        
        searchBar.returnKeyType = .done
    
        parsePokemonCSV()
        initAudio()
        
    }
    
    func initAudio(){
    
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        do{
            try audioPlayer = AVAudioPlayer(contentsOf: URL(string: path)!)
            audioPlayer.prepareToPlay()
            audioPlayer.numberOfLoops = -1
            audioPlayer.play()
        }catch{
            print(error.localizedDescription)
        }
        
    
    }

    func parsePokemonCSV(){
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do {
        
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                
                let pokemon = Pokemon(name: name, pokedexId: pokeId)
                pokemons.append(pokemon)
            }
            
        }catch let err{
            print(err.localizedDescription)
        }
    }
    
    @IBAction func musicButtonPressed(_ sender: UIButton) {
        if audioPlayer.isPlaying {
            audioPlayer.stop()
            sender.alpha = 0.2
        }else{
            audioPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    // MARK: - search bar methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            collection.reloadData()
            view.endEditing(true)
        }else{
            inSearchMode = true
 
            filterPokemons = []
            
            if let searchBarText = searchBar.text?.lowercased(){
                
                filterPokemons = pokemons.filter({$0.name.range(of: searchBarText) != nil})
                collection.reloadData()
            }
            
            
        }
    }
    
    
    // MARK: - collection view methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode {
            return filterPokemons.count
        }
        return pokemons.count
       
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pokeCell", for: indexPath) as? PokeCell {
            
            let pokemon : Pokemon!
            if inSearchMode{
                pokemon = filterPokemons[indexPath.row]
            }else{
                pokemon = pokemons[indexPath.row]
            }
            cell.configureCell(pokemon: pokemon)
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let pokemon : Pokemon!
        
        if inSearchMode{
            pokemon = filterPokemons[indexPath.row]
        }else{
            pokemon = pokemons[indexPath.row]
        }
        
        performSegue(withIdentifier: "PokemonDetailSegue", sender: pokemon)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 105, height: 105)
        
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetailSegue" {
            
            if let destinationVC = segue.destination as? PokemonDetailVC {
                if let pokemon = sender as? Pokemon {
                    destinationVC.pokemon = pokemon
                }
            }
            
        }
    }
}

