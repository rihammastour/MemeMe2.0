//
//  SentMemesTableViewController.swift
//  MemeMe1.0
//
//  Created by Riham Mastour on 21/10/1441 AH.
//  Copyright © 1441 Riham Mastour. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
    //MARK: OUTLETS
    var allMemes: [Meme]! {
        let object = UIApplication.shared.delegate
          let appDelegate = object as! AppDelegate
          return appDelegate.memes
    }
    @IBOutlet var sentMemesTableView: UITableView!
    
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.viewDidLoad()
        sentMemesTableView.reloadData()
    }
    
    
    //MARK: Add meme

    @IBAction func addMeme(_ sender: Any) {
        let genreateMemeController = self.storyboard!.instantiateViewController(withIdentifier: "GenerateMemeViewController") as! GenerateMemeViewController

                  // Present the view controller using navigation
                  navigationController!.pushViewController(genreateMemeController, animated: true)
    }
    
    
    // MARK: Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return allMemes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "SentMemeCell") as! SentMemeTableViewCell
        let memes = self.allMemes[(indexPath as NSIndexPath).row]
        
        // Set the image and label
        cell.memesImageView.image = memes.memedImage
        cell.memesLabel.text = memes.topText + " " + memes.bottomText

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          let detailedMemeController = self.storyboard!.instantiateViewController(withIdentifier: "DetailedMemeViewController") as! DetailedMemeViewController

        //Populate view controller with data from the selected item
        detailedMemeController.meme = allMemes[(indexPath as NSIndexPath).row]

        // Present the view controller using navigation
        navigationController!.pushViewController(detailedMemeController, animated: true)
    }
}
