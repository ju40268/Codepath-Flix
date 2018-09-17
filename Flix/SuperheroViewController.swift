//
//  SuperheroViewController.swift
//  Flix
//
//  Created by Christina Chen on 9/16/18.
//  Copyright © 2018 Christie Chen. All rights reserved.
//

import UIKit

class SuperheroViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
     var movies: [[String: Any]] = [];
    
    var refreshControl: UIRefreshControl! //! implicitly unwraps object
    
    
    //MARK: Alert Controls
    let alertController = UIAlertController(title: "Your Connection Needs a Flixin'!",
                                            message: "Cannot connect to databases. Is your device connected to wifi? ",
                                            preferredStyle: .alert)
    
    //create an OK button
    let okAction = UIAlertAction(title: "OK", style: .default){ (action) in
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self;
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        
        let cellsPerLine: CGFloat = 2;
        let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellsPerLine - 1)
        let width = collectionView.frame.size.width / cellsPerLine - interItemSpacingTotal / cellsPerLine;
        layout.itemSize = CGSize(width: width, height: width * 3 / 2)

        fetchMovies();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell
        
        let movie = movies[indexPath.item]
        if let posterPathString = movie["poster_path"] as? String {
            let baseURLString = "https://image.tmdb.org/t/p/w500";  //The baseURL
            let posterURL = URL(string: baseURLString + posterPathString)!
            
            cell.posterImageView.af_setImage(withURL: posterURL);
            
        }
        return cell
        
    }
    
    
    func fetchMovies(){
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!;
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10);
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main);
        
        let task = session.dataTask(with: request) { (data, response, error) in
            //This will run when the network request returns.
            if let error = error{
                print(error.localizedDescription);
            }
                
            else if let data = data{
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]; //Parses Json into Swift dictionary
                let movies = dataDictionary["results"] as! [[String: Any]]; // as! [[String: Any]] casts the object an array of swift Dictionary
                self.movies = movies;
                
                self.collectionView.reloadData();    //Network slower than compiler. Need to reload data to avoid blank page.
                //self.refreshControl.endRefreshing()
                
                
            }
        }
        
        task.resume(); //starts task.
    }
    
    
}
