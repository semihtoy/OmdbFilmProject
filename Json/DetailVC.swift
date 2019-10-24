//
//  DetailVC.swift
//  Json
//
//  Created by Xcode on 24.10.2019.
//  Copyright © 2019 Xcode. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    

    @IBOutlet weak var ResponseLabel: UILabel!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var YearLabel: UILabel!
    @IBOutlet weak var RunTimeLabel: UILabel!
    @IBOutlet weak var ActorsLabel: UILabel!                // değişkenler
    @IBOutlet weak var GenreLabel: UILabel!
    @IBOutlet weak var imdbRatingLabel: UILabel!
    
    @IBOutlet weak var PosterImage: UIImageView!
   
    
    
    
    
    
    
    
    
    var selectedFilm : Search?;    // search tipinden türetilmiş bir değişken

    override func viewDidLoad() {
        super.viewDidLoad()

        post(idmbID: (selectedFilm?.imdbID)!)   // post adlı fonksiyonun idmbıd adlı parametresine selectedfilm değişkenin içindeki datadan imdbıd sini atıyor
       
     
        // Do any additional setup after loading the view.
        if let imageURL = URL(string: (self.selectedFilm?.poster!)!) {
             DispatchQueue.global().async {
                 let data = try? Data(contentsOf: imageURL)
                 if let data = data {                                           //image url stringinden dataya datadan image dönüştürme ve ekrana basma işlemi
                     let image = UIImage(data: data)
                     DispatchQueue.main.async {
                        
                         self.PosterImage.image = image
                     }
                 }
             }
         }
            }
    

    
    func post(idmbID : String) -> Void {    // sonuç göndermeyen idmbıd adlı parametreye sahip bir fonksiyon
       
        let url = URL(string: "http://www.omdbapi.com/?apikey=ebb5f279&i=\(idmbID)&plot=full")!
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("error: \(error)")
                } else {
                    if let response = response as? HTTPURLResponse {
                        print("statusCode: \(response.statusCode)")
                    }
                    if let data = data {
                     
                     do
                     {
                        let jsonResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                        let jsonDecoder = JSONDecoder()
                        let responseModel = try jsonDecoder.decode(DetailType.self, from: data);
                      
                        print(jsonResponse)
                         DispatchQueue.main.async {
                         
                        self.ResponseLabel.text = responseModel.response
                        self.TitleLabel.text = responseModel.title
                        self.YearLabel.text = responseModel.year
                        self.RunTimeLabel.text = responseModel.runtime
                        self.ActorsLabel.text = responseModel.actors
                        self.GenreLabel.text = responseModel.genre
                        self.imdbRatingLabel.text = responseModel.imdbRating
                        
                        }
                     } catch let error {
                         print("Error", error)
                         
                     }
                     
                }
            }
         }
        task.resume();
        
        
    }

}
