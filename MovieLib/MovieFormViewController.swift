//
//  MovieFormViewController.swift
//  MovieLib
//
//  Created by Lucas Oliveira de Borba on 26/07/22.
//

import UIKit

class MovieFormViewController: UIViewController {
    
    @IBOutlet weak var textFieldTitle: UITextField!
    @IBOutlet weak var textFieldRating: UITextField!
    @IBOutlet weak var textFieldDuration: UITextField!
    @IBOutlet weak var textFieldCategories: UITextField!
    @IBOutlet weak var imageViewPoster: UIImageView!
    @IBOutlet weak var textViewSummary: UITextView!
    @IBOutlet weak var buttonAddEdit: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.keyboardDismissMode = .interactive
        
        if let movie = movie{
            title = "Edição"
            textFieldTitle.text = movie.title
            textFieldRating.text = "\(movie.rating)"
            textViewSummary.text = movie.summary
            textFieldCategories.text = movie.categories
            textFieldDuration.text = movie.duration
            if let image = movie.image{
            imageViewPoster.image = UIImage(data: image)
            }
            buttonAddEdit.setTitle("Alterar", for: .normal)
        }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    @objc func keyboardWillShow(notification: NSNotification){
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else{
            return
        }
        
        scrollView.contentInset.bottom = keyboardFrame.size.height - view.safeAreaInsets.bottom
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardFrame.size.height - view.safeAreaInsets.bottom
    }
    @objc func keyboardWillHide(){
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    
    @IBAction func selectPoster(_ sender: UIButton) {
        let alert = UIAlertController(title: "Selecionar Pôster", message: "De onde você deseja escolher o pôster?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
        
        let cameraAction = UIAlertAction(title: "Câmera", style: .default) {
            _ in
            self.selectPicture(souceType: .camera)
        }
        alert.addAction(cameraAction)
            
        }
        let libraryAction = UIAlertAction(title: "Biblioteca de Fotos", style: .default) {
            _ in
            self.selectPicture(souceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let albumAction = UIAlertAction(title: "Álbum de Fotos", style: .default) {
            _ in
            self.selectPicture(souceType: .savedPhotosAlbum)
        }
        alert.addAction(albumAction)

        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func selectPicture(souceType: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = souceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func save(_ sender: UIButton) {
        
        if movie == nil{
         movie = Movie(context: context)
        }
        
        movie?.title = textFieldTitle.text
        movie?.summary = textViewSummary.text
        movie?.categories = textFieldCategories.text
        movie?.duration = textFieldDuration.text
        movie?.rating = Double(textFieldRating.text!) ?? 0
        movie?.image = imageViewPoster.image?.jpegData(compressionQuality: 0.9)
        
        try? context.save()
        
        navigationController?.popViewController(animated: true)
    }
    
}

extension MovieFormViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage{
            imageViewPoster.image = image
        }
        dismiss(animated: true, completion: nil)
        
    }
}
