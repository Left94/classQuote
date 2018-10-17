//
//  ViewController.swift
//  classQuote
//
//  Created by vincent  on 17/10/2018.
//  Copyright © 2018 Loret Vincent. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var newQuoteButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addShadowToQuoteLabel()
    }
    
    
    private func addShadowToQuoteLabel() {
        quoteLabel.layer.shadowColor = UIColor.black.cgColor
        quoteLabel.layer.shadowOpacity = 0.9
        quoteLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
    }
    
    
    @IBAction func tappedNewQuoteButton() {
        toggleActivityIndicator(shown: true)
        QuoteService.shared.getQuote { (success, quote) in
        self.toggleActivityIndicator(shown: false)
            self.newQuoteButton.isHidden = false
            self.activityIndicator.isHidden = true
            if success, let quote = quote {
                //Afficher la citation
                self.update(quote: quote)
            } else {
                //Presenter un message d'erreur
                self.presentAlert()
            }
        }
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        newQuoteButton.isHidden = shown
        activityIndicator.isHidden = !shown
        }
    
    private func update(quote: Quote) {
        quoteLabel.text = quote.text
        authorLabel.text = quote.author
        imageView.image = UIImage(data: quote.imageData)
    }
    
    private func presentAlert() {
        let alertVC = UIAlertController(title: "Error", message: "The Quote Download failed", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}

