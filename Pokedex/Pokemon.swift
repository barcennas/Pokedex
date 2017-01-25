//
//  Pokemon.swift
//  Pokedex
//
//  Created by Abraham Barcenas M on 1/19/17.
//  Copyright © 2017 barcennas. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name : String!
    private var _pokedexId : Int!
    private var _description : String!
    private var _type : String!
    private var _defence : String!
    private var _height : String!
    private var _weight : String!
    private var _attack : String!
    private var _nextEvolutionId : String!
    private var _nextEvolutionName : String!
    private var _nextEvolutionLvl : String!
    private var _pokemonURL : String!
    
    var name : String {
        return _name
    }
    
    var pokedexId : Int {
        return _pokedexId
    }
    
    var description : String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type : String{
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defence : String{
        if _defence == nil {
            _defence = ""
        }
        return _defence
    }
    
    var height : String{
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight : String{
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack : String{
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolutionId : String{
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionName : String{
        if _nextEvolutionName == nil {
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    var nextEvolutionLvl : String{
        if _nextEvolutionLvl == nil {
            _nextEvolutionLvl = ""
        }
        return _nextEvolutionLvl
    }
    
    init(name : String, pokedexId : Int){
        self._name = name
        self._pokedexId = pokedexId
        
        self._pokemonURL = "\(URL_BASE)\(API_VERSION1)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    
    func downloadPokemonDetail(completed : @escaping DownloadComplete){
        
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject>{
            
                if let weight = dict["weight"] as? String{
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String{
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int{
                    
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int{
                    self._defence = "\(defense)"
                }
                
                if let types = dict["types"] as? [Dictionary<String, String>] , types.count > 0{
                    
                    if let name = types[0]["name"]{
                        self._type = name.capitalized
                    }
                    
                    if types.count > 1 {
                        
                        for x in 1..<types.count {
                            if let name = types[x]["name"]{
                                self._type! += "/\(name.capitalized)"
                            }
                        }
                        
                    }
                    
                }
                
                if let descriptions = dict["descriptions"] as? [Dictionary<String, String>], descriptions.count > 0 {
                    if let urlDescription = descriptions[0]["resource_uri"] {
                        
                        let completeURL = URL_BASE+urlDescription
                        
                        Alamofire.request(completeURL).responseJSON(completionHandler: { (response) in
                            
                            if let descDict = response.result.value as? Dictionary<String, AnyObject> {
                                if let description = descDict["description"] as? String {
                                    let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    self._description = newDescription
                                }
                            }
                         completed()
                        })
                    }
                }else{
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>], evolutions.count > 0{
                    if let evolutionName = evolutions[0]["to"] as? String{
                        
                        //just when it's a normal evolution
                        if evolutionName.range(of: "mega") == nil {
                        
                            self._nextEvolutionName = evolutionName
                            
                            if let evolutionLvl = evolutions[0]["level"] as? Int {
                                self._nextEvolutionLvl = "\(evolutionLvl)"
                            } else{
                                self._nextEvolutionLvl = ""
                            }
                            
                            if let evolutionString = evolutions[0]["resource_uri"] as? String {
                                var evolutionId = evolutionString.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                evolutionId = evolutionId.replacingOccurrences(of: "/", with: "")
                                self._nextEvolutionId = evolutionId
                                
                            }
                            
                        }
                        
                    }
                    
                }
                

            }
            
         completed()
        }
    }
    

}
