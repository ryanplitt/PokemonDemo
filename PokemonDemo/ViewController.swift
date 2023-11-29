//
//  ViewController.swift
//  PokemonTestingDemo
//
//  Created by Ryan Plitt on 11/28/23.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var pokemonLabel: UILabel!
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonLabel.text = ""
    }


    @IBAction func goButtonTapped(_ sender: Any) {
        numberTextField.resignFirstResponder()
        guard let id = Int(numberTextField.text!) else {
            return print("There was an error getting a number")
        }
        pokemonLabel.text = ""
        pokemonImageView.image = nil
        activityIndicator.startAnimating()
        Task {
            let modelController = ModelController()
            let pokemon = await modelController.fetchPokemon(number: id)
            pokemonLabel.text = pokemon?.name.capitalized
            let (data, _) = try! await URLSession.shared.data(from: URL(string: pokemon!.imageURL)!)
            let image = UIImage(data: data)
            activityIndicator.stopAnimating()
            pokemonImageView.image = image
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        goButtonTapped(self)
        return true
    }
}

