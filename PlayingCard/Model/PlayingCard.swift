//
//  PlayingCard.swift
//  PlayingCard
//
//  Created by Sara Elsayed Salem on 12/26/18.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation

struct PlayingCard:CustomStringConvertible { //CustomStringConvertible converting an instance(obj) to a string it call description
    
    var description: String {
        return "\(suit) , \(rank)"
    }
    var suit:Suit
    var rank:Rank
    //shapes
    enum Suit:String,CustomStringConvertible {  //rawValue string
        
        var description: String{
            return rawValue
//            switch self { //Rank
//            case .spades: return  "♠️"
//            case .hearts : return "❤️"
//            case .clubs : return "♣️"
//            case .diamonds : return "♦️"
////            default: return "??"
//            }
        }
        //raw value
        case spades = "♠️"
        case hearts = "❤️"
        case clubs = "♣️"
        case diamonds = "♦️"
        static var all = [Suit.spades,.hearts,.clubs,.diamonds]
        
    }
    enum Rank :CustomStringConvertible{
        
        var description: String{
            switch self { //Rank
            case .ace: return "A"
            case .face(let kind) : return kind
            case .numeric(let pips) : return String(pips)
//            default: return "??"
            }
        }
        
        case ace //A
        case face(String) //j k Q
        case numeric(Int) //2...10
        
        var order:Int { // value of ranks
            switch self {
            case .ace: return 1
            case .face(let kind) where kind == "J" : return 11
            case .face(let kind) where kind == "Q" : return 12
            case .face(let kind) where kind == "K" : return 13
            case .numeric(let pips) : return pips //suits on face
            default:
                return 0
            }
        }
        
        static var all : [Rank]{
            var allRanks = [Rank.ace]
            for pips in 2...10{
                allRanks.append(.numeric(pips))
            }
             allRanks+=[Rank.face("J"),.face("Q"),.face("K")]
            return allRanks
        }
        
    }
}
