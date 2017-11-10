//
//  DetailViewController.swift
//  Project3
//
//  Created by Linix on 2017/2/17.
//  Copyright © 2017年 Linix. All rights reserved.
//

import UIKit
import Social

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var selectedImage: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedImage
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    func shareTapped() {

        // Creates a UIActivityViewController, which is the iOS method of sharing content with other apps and services
        let vc = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: [])
        
        // This line tells IOS to anchor the activity view controller to the right bar button item (our share button), but this only has an effect on iPad – on iPhone it's ignored.
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
/*
        // 使用Social SLComposeViewController 分享到facebook, tweeter和微博
        if let vc = SLComposeViewController(forServiceType: SLServiceTypeTencentWeibo) {
            vc.setInitialText("Look at this great picture")
            vc.add(imageView.image!)
            vc.add(URL(string: "http://http://www.photolib.noaa.gov/nssl"))
            present(vc, animated: true)
        }
 */
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
