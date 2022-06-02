//
//  DetailsViewController.swift
//  pizzaHunter
//
//  Created by david on 1/19/22.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var phone: UILabel!
    
    var currentPizzaShop: pizzaShop!
    

    override func viewDidLoad()
    {
        super.viewDidLoad()

        name.text = currentPizzaShop.name
        address.text = currentPizzaShop.address
        phone.text = currentPizzaShop.phoneNumber
    }
    
    @IBAction func dismiss(_ sender: UIButton)
    {
    dismiss(animated: true, completion: nil)
    }
    
    
}
