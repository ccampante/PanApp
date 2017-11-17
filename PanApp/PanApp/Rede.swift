//
//  Rede.swift
//  PanApp
//
//  Created by Carlos R C Campante on 17/11/2017.
//  Copyright © 2017 CRCC. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import CoreData

class Rede {
    
    private struct BaseURL{
        static var serverBase = "https://api.twitch.tv/kraken/games/top"
    }
    
    private struct AutorizaRequest {
        static var clientID = "23mp4lduhqpildxud92jmok2g6u8lw"
    }
    
    func carregaJogosApi()-> Void {
        
        limpaJogos()
        
        let caminho = BaseURL.serverBase + "?client_id=" + AutorizaRequest.clientID
        
        Alamofire.request(caminho)
            .responseJSON(completionHandler: {
                response in
                self.parseData(JSONData: response.data!)
            })
    }
    
    func parseData(JSONData: Data) {
        do {
            let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options:.allowFragments) as! [String: Any]
            
            let itemsJson = readableJSON["top"] as! NSArray//[[String: Any]]
            
            //visualizações
            let visualizacoesArray = itemsJson.value(forKey: "viewers") as! NSArray
            
            //canais
            let canaisArray = itemsJson.value(forKey: "channels") as! NSArray
            
            let jogoArray = itemsJson.value(forKey: "game") as! NSArray
            
            var index = 0
            
            for jogo in jogoArray {
                
                let jogoDict = jogo as! NSDictionary
                
                let nomeJogo = jogoDict.value(forKey: "name")! as! String
                let boxDict = jogoDict.value(forKey: "box") as! NSDictionary
                let imgGrande = boxDict.value(forKey: "large")! as! String
                let imgMedia = boxDict.value(forKey: "medium")! as! String
                let imgPequena = boxDict.value(forKey: "small")! as! String
                let qtdVisualizacoes = visualizacoesArray[index] as! Int32
                let qtdCanais = canaisArray[index] as! Int32
                
                //salvar novo jogo
                let item = JogoTwitch()
                item.nome = nomeJogo
                item.imagemGrande = imgGrande
                item.imagemMedia = imgMedia
                item.imagemPequena = imgPequena
                item.qtdCanais = qtdCanais
                item.qtdVisualizacoes = qtdVisualizacoes
                gravaJogo(jogoObj: item)
                
                index += 1
            }
            
        }
        catch {
            print(error)
        }
    }
    
    func gravaJogo(jogoObj: JogoTwitch) {
        //core data
        let context = (UIApplication.shared.delegate as! AppDelegate!).persistentContainer.viewContext
        
        //novo jogo
        let jogo = NSEntityDescription.insertNewObject(forEntityName: "Jogo", into: context)
        
        jogo.setValue(jogoObj.nome!.uppercased(), forKey: "nome")
        jogo.setValue(jogoObj.imagemGrande, forKey: "imagem_grande")
        jogo.setValue(jogoObj.imagemMedia, forKey: "imagem_media")
        jogo.setValue(jogoObj.imagemPequena, forKey: "imagem_pequena")
        jogo.setValue(jogoObj.qtdCanais, forKey: "qtd_canais")
        jogo.setValue(jogoObj.qtdVisualizacoes, forKey: "qtd_visualizacoes")
        
        //salvar
        do {
            try context.save()
            //salvo
            print("salvo novo jogo")
        } catch {
            //erro
        }
    }
    
    func obterJogos()-> [JogoTwitch] {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Jogo")
        
        var jogoArray:[JogoTwitch] = []
        
        do {
            let results = try context.fetch(fetchRequest)
            let jogosObj = results as! [Jogo]
            
            for j in jogosObj {
                //print(jogoObj.nome!.uppercased())
                
                let item = JogoTwitch()
                item.nome = j.nome!.uppercased()
                item.imagemGrande = j.imagem_grande
                item.imagemMedia = j.imagem_media
                item.imagemPequena = j.imagem_pequena
                item.qtdCanais = j.qtd_canais
                item.qtdVisualizacoes = j.qtd_visualizacoes
                
                jogoArray.append(item)
            }
            
        }catch let err as NSError {
            print(err.debugDescription)
        }
        return jogoArray
    }
    
    func limpaJogos() {
        let context = (UIApplication.shared.delegate as! AppDelegate!).persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Jogo")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("Erro ao deletar registros.")
        }
    }
    
}

