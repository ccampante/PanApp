//
//  Twitch.swift
//  PanApp
//
//  Created by Carlos R C Campante on 15/11/2017.
//  Copyright © 2017 CRCC. All rights reserved.
//

import UIKit

class Twitch {
    
    func temRegistros()-> Bool {
        
        let itensJogos:[JogoTwitch] = Rede().obterJogos()
        
        if (itensJogos.count > 0) {
            return true
        } else {
            return false
        }
    }
    
    func atualizaApi()-> Void {
        
        Rede().downloadApi()
    }
    
    func obterDadosApi()-> [JogoTwitch] {
        
        return Rede().downloadDados()
    }
    
    func obterJogos()-> [JogoTwitch] {
        
        return Rede().obterJogos()
    }
    
    func incluiJogo(jogo: JogoTwitch)-> Void {
        
        Rede().gravaJogo(jogoObj: jogo)
        
    }

}


