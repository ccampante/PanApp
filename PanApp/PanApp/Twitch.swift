//
//  Twitch.swift
//  PanApp
//
//  Created by Carlos R C Campante on 15/11/2017.
//  Copyright © 2017 CRCC. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class Twitch {
    
    private struct BaseURL{
        static var serverBase = "https://api.twitch.tv/kraken/games/top"
    }
    
    private struct AutorizaRequest {
        static var clientID = "23mp4lduhqpildxud92jmok2g6u8lw"
    }
    
    func carregaJogos()-> Void {
        
        let caminho = BaseURL.serverBase + "?client_id=" + AutorizaRequest.clientID
        
        Alamofire.request(caminho)
            .responseJSON(completionHandler: {
                response in
                self.parseData(JSONData: response.data!)
                
                //self.collectionView.reloadData()
            })
        
//        Alamofire.request(caminho, method: .get, encoding: JSONEncoding.default)
//            .responseJSON { response in
//                debugPrint(response)
//
//                if let data = response.result.value{
//
//                    print("Teste: \(data)")
//
//                    let parseJson = JSONSerialization.data(withJSONObject: data, options: JSONSerialization.ReadingOptions.mutableContainers)
//
//                    if  (data as? [[String : AnyObject]]) != nil{
//
//                        if let dictionaryArray = data as? Array<Dictionary<String, AnyObject?>> {
//                            if dictionaryArray.count > 0 {
//
//                                for i in 0..<dictionaryArray.count{
//
//                                    let Object = dictionaryArray[i]
//
//                                    //if let email = Object["email"] as? String{
//                                    //    print("Email: \(email)")
//                                    //}
//                                    //if let uId = Object["uId"] as? Int{
//                                    //    print("User Id: \(uId)")
//                                    //}
//                                    // like that you can do for remaining...
//
//                                    //Salvar jogos - Core Data
//                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                                    let context = appDelegate.persistentContainer.viewContext
//
//                                    //Novo jogo
//                                    let jogo = NSEntityDescription.insertNewObject(forEntityName: "Jogo", into: context)
//
//                                    //jogo.setValue(<#T##value: Any?##Any?#>, forKey: <#T##String#>)
//
//                                    do {
//                                        //try context.save()
//                                        //salvo
//                                        print("salvo novo jogo")
//                                    } catch {
//                                        //erro
//                                    }
//
//                                }
//                            }
//                        }
//                    }
//                }
//                else {
//                    let error = (response.result.value  as? [[String : AnyObject]])
//                    print(error as Any)
//                }
//        }
    }
    
    func parseData(JSONData: Data) {
        do {
            let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options:.allowFragments) as! [String: Any]
            
            let itemsJson = readableJSON["top"] as! NSArray//[[String: Any]]
            
            //visualizações
            let visualizacoesArray = itemsJson.value(forKey: "viewers") as! NSArray
            //print("Visualizacao: \(visualizacoes[1])")
            
            //canais
            let canaisArray = itemsJson.value(forKey: "channels") as! NSArray
            
            //print("Views: \(itemsJson.value(forKey: "viewers"))")
            //print("Views: \(itemsJson.value(forKey: "channels"))")
            
            let jogoArray = itemsJson.value(forKey: "game") as! NSArray
            
            var index = 0
            
            for jogo in jogoArray {
                
                let jogoDict = jogo as! NSDictionary
                
                print("Nome: \(jogoDict.value(forKey: "name")!)")
                let nomeJogo = jogoDict.value(forKey: "name")! as! String
                
                let boxDict = jogoDict.value(forKey: "box") as! NSDictionary
                
                print("Img_Grande: \(boxDict.value(forKey: "large")!)")
                let imgGrande = boxDict.value(forKey: "large")! as! String
                print("Img_Grande: \(boxDict.value(forKey: "medium")!)")
                let imgMedia = boxDict.value(forKey: "medium")! as! String
                print("Img_Grande: \(boxDict.value(forKey: "small")!)")
                let imgPequena = boxDict.value(forKey: "small")! as! String
                
                print("Visualizacões: \(visualizacoesArray[index])")
                let qtdVisualizacoes = visualizacoesArray[index] as! Int
                print("Canais: \(canaisArray[index])")
                let qtdCanais = canaisArray[index] as! Int
                
                //core data
                //let appDelegate = UIApplication.shared.delegate as! AppDelegate
                //let context = appDelegate.persistentContainer.viewContext
                
                let context2 = (UIApplication.shared.delegate as! AppDelegate!).persistentContainer.viewContext

                
                //novo jogo
                let jogo = NSEntityDescription.insertNewObject(forEntityName: "Jogo", into: context2)
                
                jogo.setValue(nomeJogo, forKey: "nome")
                jogo.setValue(imgGrande, forKey: "imagem_grande")
                jogo.setValue(imgMedia, forKey: "imagem_media")
                jogo.setValue(imgPequena, forKey: "imagem_pequena")
                jogo.setValue(qtdCanais, forKey: "qtd_canais")
                jogo.setValue(qtdVisualizacoes, forKey: "qtd_visualizacoes")
                
                //salvar
                do {
                    try context2.save()
                    //salvo
                    print("salvo novo jogo")
                } catch {
                    //erro
                }
                
                index += 1
                
            }
            
        }
        catch {
            print(error)
        }
    }
    
    
}


