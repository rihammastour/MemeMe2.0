//
//  SentMemeCollectionViewController.swift
//  MemeMe1.0
//
//  Created by Riham Mastour on 21/10/1441 AH.
//  Copyright © 1441 Riham Mastour. All rights reserved.
//

import UIKit

class SentMemeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // Get shared Memes
    var allMemes: [Meme]! {
        let object = UIApplication.shared.delegate
          let appDelegate = object as! AppDelegate
          return appDelegate.memes
    }

    @IBOutlet var sentMemesCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.viewDidLoad()
        sentMemesCollectionView!.reloadData()
    }
    
    
    //MARK: Add meme
    
    @IBAction func addMeme(_ sender: Any) {
       let genreateMemeController = self.storyboard!.instantiateViewController(withIdentifier: "GenerateMemeViewController") as! GenerateMemeViewController

               // Present the view controller using navigation
               navigationController!.pushViewController(genreateMemeController, animated: true)
    }
    

    // MARK: Collection view data source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allMemes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentMemesCell", for: indexPath) as! SentMemesCollectionViewCell
        let memes = self.allMemes[(indexPath as NSIndexPath).row]

        // Set the image
        cell.memesImageView.image = memes.memedImage
        
        return cell

    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let detailedMemeController = self.storyboard!.instantiateViewController(withIdentifier: "DetailedMemeViewController") as! DetailedMemeViewController

        //Populate view controller with data from the selected item
        detailedMemeController.meme = allMemes[(indexPath as NSIndexPath).row]

        // Present the view controller using navigation
        navigationController!.pushViewController(detailedMemeController, animated: true)
    }
    
    
    //MARK: Restyle cells
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // resize the cell
        return CGSize(width: (view.frame.size.width - (2 * 6)) / 3.0, height: (view.frame.size.width - (2 * 6)) / 3.0)

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        // Minimum Interitem Spacing For Section
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // Minimum Line Spacing For Section
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        // Padding
        return UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3)
    }

}
