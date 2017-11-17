//
//  ListaViewController.swift
//  PanApp
//
//  Created by Carlos R C Campante on 15/11/2017.
//  Copyright © 2017 CRCC. All rights reserved.
//

import UIKit

class ListaViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var listaJogos: UICollectionView!
    
    //var dadosArray : NSMutableArray = []
    
    var refreshControl:UIRefreshControl!
    
    var dadosJogos:[JogoTwitch] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.listaJogos.delegate = self
        self.listaJogos.dataSource = self
        
        populaListaJogos()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(atualizar), for: .valueChanged)
        listaJogos.refreshControl = refreshControl
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func atualizar() {
        DispatchQueue.global(qos: .background).async {
            
            // Carrega os dados da api
            Twitch().carregaApi()
            
            // Go back to the main thread to update the UI
            DispatchQueue.main.async {
                //retorno
                self.dadosJogos = Twitch().carregaJogos()
                self.listaJogos.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dadosJogos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JogoCell", for: indexPath) as! JogoCollectionViewCell
        
        cell.lblNomeJogo.text = dadosJogos[indexPath.row].nome
        
        return cell
    }
    
    func populaListaJogos() {
        
        if (Twitch().temRegistros()) {
            
            self.dadosJogos = Twitch().carregaJogos()
            self.listaJogos.reloadData()
            
        } else {
            
            atualizaListaApi()
        }
    }
    
    func atualizaListaApi() {
        DispatchQueue.global(qos: .background).async {
            
            // Carrega os dados da api
            Twitch().carregaApi()
            
            // Go back to the main thread to update the UI
            DispatchQueue.main.async {
                //retorno
                self.dadosJogos = Twitch().carregaJogos()
                self.listaJogos.reloadData()
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
