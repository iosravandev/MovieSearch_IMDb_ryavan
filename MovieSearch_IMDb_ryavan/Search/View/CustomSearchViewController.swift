//
//  CustomSearchViewController.swift
//  MovieSearch_IMDb_ryavan
//
//  Created by Ravan on 29.09.24.
//
import UIKit

protocol CustomSearchBarDelegate: AnyObject {
    func searchBarDidSubmit(_ searchText: String)
}

class CustomSearchBar: UIView, UITextFieldDelegate {
    
    var searchViewModel = SearchViewModel()
    
    weak var delegate: CustomSearchBarDelegate?
    
    var searchText: String {
            return searchTextField.text ?? ""
    }
    
    private let searchIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "searchicon")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Search here what you want to watch..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        searchTextField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        addSubview(searchIcon)
        addSubview(searchTextField)
        
        NSLayoutConstraint.activate([
            
            searchTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -16),
            searchTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 16),
            
            searchIcon.topAnchor.constraint(equalTo: searchTextField.topAnchor, constant: 0),
            searchIcon.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: -16),
            searchIcon.bottomAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 0)
                        
        ])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            if let searchText = textField.text, !searchText.isEmpty {
                delegate?.searchBarDidSubmit(searchText)
            }
            return true
    }
        
}
