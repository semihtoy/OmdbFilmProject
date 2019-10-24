//
//  ViewController.swift
//  Json
//
//  Created by Xcode on 23.10.2019.
//  Copyright © 2019 Xcode. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var TextField: UITextField!  // search için kullandığımız textfieldin tanımı
    @IBAction func SearchButton(_ sender: Any) {   // search için kullandığımız buttonun tanımı
        
        self.get(MovieTitle: self.TextField.text!);    // get() fonksiyonunun movietitle parametresine textfieldin textindeki veriyi gönderiyoruz butona basınca
          
            self.Table.reloadData()                     // table adlı tableviewin içindeki dataları güncelledik butona basınca
                  
        
        
    }
   
    var films = [Search]()  // Search type dan films diye bir değişken tanımladık bu films array formatında
    
    var chosenFilm : Search?;   //  Seçilen veriyi bir yerde tutmamız gerektiğinden bunu tanımladık
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {  // tableview in default fonksiyonlarında kaç tane row olacağını belirtir
        return films.count                                                                  // films countu kadar row gönderecek
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {  // tableview default fonksiyonudur rowlara basılacak verileri belirler
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FilmItemCell") as?   // Films adlı clastaki itemlere cell adlı değişkenle ulaştık
            Films else { return UITableViewCell() } //
        cell.tiTle.text =  films[indexPath.row].title! // title nin textine row daki nin title atadık
        cell.Yearr.text = films[indexPath.row].year!  // year ın textine row daki nin yearını atadık
        if let imageURL = URL(string: films[indexPath.row].poster!) { // url tipinde bi image url tanımladık o url ye de films. posterindeki url yi atadık
            DispatchQueue.global().async {  // ne boka yaradığını bilmiyorum ama async çalışmasını sağlıyor muhtemelen
                let data = try? Data(contentsOf: imageURL)  // data adlı değişkene url deki data ya çevirip gönderiyor
                if let data = data { // bu bir kalıp ama kalıbı tam anlamadım
                    let image = UIImage(data: data) // image adlı değişkene datayı image çevirip atıyor
                    DispatchQueue.main.async {   // async çalıştırdı yine
                        cell.ImageView.image = image // imageview içine image bastı
                    
                    }
                }
            }
        }
        return cell // fonksiyon cell dönüyor
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // seçili row un
        chosenFilm = films[indexPath.row];                                          // içinde films verilerini chosenfilm adlı değişkene aktardık
        self.performSegue(withIdentifier: "toDetailVC", sender: nil)                 // seçtiğimiz rowa tıklayınca bir geçiş işlemi yapıyoruz bu geçiş todetailvc üzerinden
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {       // seque işlemi
        if segue.identifier == "toDetailVC" {                                  // yaparken eğer identifier todetailvc eşitse 
            let destinationVC = segue.destination as! DetailVC                //  destinationvc değişkenine geçiş yapılırken
            destinationVC.selectedFilm = chosenFilm                            // chosenfilm deki verileri dedailvc içinde tanımladığımız selectedfilm adlı değişkene atıyoruz
    }                                                                                       // detailvc de kullanabilmek için
    }
    @IBOutlet weak var Table: UITableView! //table adlı bir tableview
    
  
    override func viewDidLoad() { // uygulama ilk çalıştığında çalışan fonksiyon
        super.viewDidLoad()
   
    
        Table.delegate = self   // tableviewe basılan verileri görebilmek
        Table.dataSource = self  // için kullanılan kalıplar
        
        self.get(MovieTitle: "lord");  // get func da link için default ayarladığımız string
        DispatchQueue.main.async {   // async çalıştırdık yine
            self.Table.reloadData()    // tableview deki verileri güncelledik çalışmadan önce gelen verileri ekranda göstermek için
        }
        
    }
    
    
    func get(MovieTitle: String) -> Void { // movetitle adlı paramatreye sahip olan void bir func
        
        let url = URL(string: "http://www.omdbapi.com/?apikey=ebb5f279&type=movie&s=\(MovieTitle)")! // url adlı değişkeni url tipinde bir string atadık
        	    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in // bu url den dönecek olan 3 farklı sonuç var data, respons, error
                if let error = error { // eğer error dönerse
                    print("error: \(error)") // error mesajı bastırıyoruz console
                } else {                    // error dönmezse
                    if let response = response as? HTTPURLResponse { // response adlı değişkene url den dönen repons kodunu atıyoruz
                        print("statusCode: \(response.statusCode)")   // bu kodu console yazdırıyoruz
                    }
                    if let data = data { // data adlı değişkene url den gelen datayı atıyoruz
                        
                        do  // bunu  yap  data = data dan sonra diyor
                     {
                        let jsonDecoder = JSONDecoder()   // jsondecoder adlı değişkene jsondecoder formatında
                        let responseModel = try jsonDecoder.decode(Json4Swift_Base.self, from: data); // responsemodel adlı değişkene json4swift type deki datayı atmayı deniyor
                        self.films = responseModel.search!;   // films adlı değişkene responsmodeldeki datanın içinden search atıyoruz search Search adlı arrayden den türemiş
                         
                        
                        
                     } catch let error { // bunu yapamazsa catch bloğu çalışacak
                         print("Error", error) // console error yazdıracak
                         
                     }
                     
                }
            }
         }
        task.resume(); // fonc sürekli çalışabilmesi için 
        
        
    }
    
    
  /*
    func get() -> Void {
        
    
    let url = URL(string: "http://www.omdbapi.com/?apikey=ebb5f279&type=movie&s=lord")
            
            let session = URLSession.shared
            
            //Closure
            
            let task = session.dataTask(with: url!) { (data, response, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    // 2.
                    if data != nil {
                        do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                            
                            //ASYNC
                            
                            DispatchQueue.main.async {
                                
                                // print(jsonResponse["Search"])
                                if let search = jsonResponse["Search"] as? [String : Any] {
                                    
                                }
                            }
                            
                            
                        } catch {
                           print("error")
                        }
                        
                    }
                    
                    
                }
            }
            
            task.resume()
            
            
        }
 */
}




    

