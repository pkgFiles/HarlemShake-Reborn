/*
 
 MIT License

 Copyright (c) 2025 ★ Install Package Files

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
*/

import UIKit

class HSCreditView: UIView {

    //MARK: - Propertys
    private lazy var titleLabel: UILabel = {
        let label = UILabel().createLabelWithFontPath(text: self.username.user, fontSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel().createLabelWithFontPath(text: "@" + self.username.shorthand, fontSize: 13)
        label.textColor = UIColor.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(contentsOfFile: prefsAssetsPath + "Credits/DefaultIcon.png"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: - Variables
    let username: (user: String, shorthand: String)
    let avatarUrlString: String
    
    //MARK: - Initializer
    init(username: (user: String, shorthand: String), avatarUrlString: String) {
        self.username = username
        self.avatarUrlString = avatarUrlString
        
        super.init(frame: .zero)
        setupCreditView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Instance Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarImageView.layer.cornerRadius = 10
        avatarImageView.layer.masksToBounds = true
    }
    
    //MARK: - Functions
    private func setupCreditView() {
        getProfilePicture(from: self.avatarUrlString)
        
        self.addSubview(avatarImageView)
        self.addSubview(titleLabel)
        self.addSubview(subtitleLabel)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            avatarImageView.heightAnchor.constraint(equalToConstant: 40),
            avatarImageView.widthAnchor.constraint(equalToConstant: 40),

            titleLabel.topAnchor.constraint(equalTo: self.centerYAnchor, constant: -17.5),
            titleLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -3),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    func getProfilePicture(from urlString: String) {
        guard let url = URL(string: "https://pbs.twimg.com/profile_images/" + urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.avatarImageView.image = image
                }
            }
        }.resume()
    }
}
