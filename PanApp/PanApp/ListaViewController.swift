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
    var jogos = ["Teste1","Teste2","Teste3","Teste4","Teste5","Teste6","Teste7","Teste8","Teste9","Teste10","Teste11","Teste12"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.listaJogos.delegate = self
        self.listaJogos.dataSource = self
        
        carregaDados()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jogos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JogoCell", for: indexPath) as! JogoCollectionViewCell
        
        cell.lblNomeJogo.text = jogos[indexPath.row]
        return cell
    }
    
    func carregaDados() {
        
        DispatchQueue.global(qos: .background).async {
            
            // Carrega os dados da api
            
            //let result = self.validate(thisEmail, password: thisPassword)
            Twitch().carregaJogos()
            
            // Go back to the main thread to update the UI
            DispatchQueue.main.async {
                //fim
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
