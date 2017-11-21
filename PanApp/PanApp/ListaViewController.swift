//
//  ListaViewController.swift
//  PanApp
//
//  Created by Carlos R C Campante on 15/11/2017.
//  Copyright © 2017 CRCC. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ListaViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var listaJogos: UICollectionView!
    
    var refreshControl:UIRefreshControl!
    
    var dadosJogos:[JogoTwitch] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.listaJogos.delegate = self
        self.listaJogos.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(atualizar), for: .valueChanged)
        listaJogos.refreshControl = refreshControl
        
        //Rede().limpaJogos()

        self.atualizaTela()
    }
    
    @objc func atualizar() {
        self.refreshControl.endRefreshing()
        self.atualizaTela()
    }
    
    func atualizaTela() {
        self.dadosJogos = Twitch().obterJogos()
        self.listaJogos.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.listaJogos.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dadosJogos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JogoCell", for: indexPath) as! JogoCollectionViewCell
        
        cell.lblNomeJogo.text = dadosJogos[indexPath.row].nome
        
        if (dadosJogos[indexPath.row].imagemPequena != nil) {
            
            let urlPequena = dadosJogos[indexPath.row].imagemPequena!
            
            //let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
            //Alamofire.download(urlPequena, to: destination)
            
            Alamofire.request(urlPequena).responseImage { response in
                
                if let image = response.result.value {
                    cell.imgCapa.image = image
                }
            }
            
        } else {
            cell.imgCapa.image = UIImage(named: "capa-teste")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let tela =  self.storyboard?.instantiateViewController(withIdentifier: "JogoDetalhe") as? JogoDetalheViewController
        tela!.nome = dadosJogos[indexPath.row].nome
        tela!.visualizacoes = String(describing: dadosJogos[indexPath.row].qtdVisualizacoes!)
        tela!.canais = String(describing: dadosJogos[indexPath.row].qtdCanais!)
        tela!.capaUrl = dadosJogos[indexPath.row].imagemPequena
        self.present(tela!, animated: true, completion: nil) //.navigationController?.pushViewController(tela!, animated: true)
    }

}
