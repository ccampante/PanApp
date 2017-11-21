//
//  JogoDetalheViewController.swift
//  PanApp
//
//  Created by Carlos R C Campante on 20/11/2017.
//  Copyright © 2017 CRCC. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class JogoDetalheViewController: UIViewController {

    @IBOutlet weak var lblNome: UILabel!
    @IBOutlet weak var imgCapa: UIImageView!
    @IBOutlet weak var lblVisualizacoes: UILabel!
    @IBOutlet weak var btnVoltar: UIButton!
    @IBOutlet weak var lblCanais: UILabel!
    
    var nome:String?
    var visualizacoes:String?
    var canais:String?
    var capaUrl:String?
    
    @IBAction func voltar(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        //navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        lblNome.text = nome!
        lblCanais.text = "Canais: " + canais!
        lblVisualizacoes.text = "Visualizações: " + visualizacoes!
        
        Alamofire.request(capaUrl!).responseImage { response in
            
            if let image = response.result.value {
                self.imgCapa.image = image
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
