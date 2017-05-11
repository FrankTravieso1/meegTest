//
//  KeyboardViewController.swift
//  keyboard
//
//  Created by Frank Travieso on 2/5/17.
//  Copyright © 2017 frank. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionEmojis: UICollectionView!
    @IBOutlet var nextKeyboardButton: UIButton!
    var emojis = [URL]()
    var myArray = [UIImage]()
    
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        print("le")
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("epa")
        
        getEmojis()
        setEmojis()
        setCollectionEmojisLayout()
        
        // Perform custom UI setup here
        self.nextKeyboardButton = UIButton(type: .system)
      
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        
        //self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        self.nextKeyboardButton.addTarget(self, action: #selector(UIInputViewController.advanceToNextInputMode), for: .touchUpInside)
        self.view.addSubview(self.nextKeyboardButton)
        
        self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.blue
        }
        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }
    
    
    func getEmojis() {
        
        
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.frank.meegTest")?.appendingPathComponent("emojis")
        do {
            
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsDirectory!, includingPropertiesForKeys: nil, options: [])
            
            self.emojis = directoryContents
            
        } catch  {
            
        }
        
    }
    
    func setEmojis(){
    
        emojis.forEach{
            

                myArray.append(UIImage(contentsOfFile: $0.path)!)
            
        }
    
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return myArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! CollectionViewCell
        cell.emoji.image = myArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("seleccionaste el emoji \(indexPath.row)")
        
        let image = myArray[indexPath.row]
        
        let pb = UIPasteboard.general
        
        let pngType = UIPasteboardTypeListImage[0] as! String
        
        pb.image = image
        
        pb.setData(UIImagePNGRepresentation(image)!, forPasteboardType: pngType)
    }
    
    
    @IBAction func next(_ sender: Any) {
        print("ejele")
        self.advanceToNextInputMode()
        
    }
    
    func setCollectionEmojisLayout(){
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: self.view.bounds.width/4, height: self.view.bounds.height/2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        self.collectionEmojis!.collectionViewLayout = layout
        
        collectionEmojis.isPagingEnabled = true
        collectionEmojis.contentOffset.x = 0.0
        
    }
    
}

class KeyboardKeyCollectionViewCell: UICollectionViewCell {
    var emoji: UIImageView!
}
