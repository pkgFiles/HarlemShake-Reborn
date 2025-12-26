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

import Preferences
import HarlemShakeRebornPrefsC

@available(iOS 13.0, *)
class HarlemShakeMainVC: PSListController {

    //MARK: - Propertys
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 325))
    
    //MARK: - Variables
    var mainDeveloper: Developer = .init(name: "★ Install Package Files", shorthand: "pkgFiles", social: [.twitterX, .kofi])
    
    //MARK: - Initializers
    override init(forContentSize contentSize: CGSize) {
        super.init(forContentSize: contentSize)
        
        JailbreakTweakManager.shared.configure(with: jbroot("/"))
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    //MARK: - Instance Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let avatarURL = URL(string: "https://github.com/\(mainDeveloper.shorthand).png") else { return }
        try? RESTful.shared.download(at: avatarURL, completion: { [weak self] result in
            switch result {
            case .success(let avatarData):
                self?.mainDeveloper.avatar = UIImage(data: avatarData)
                DispatchQueue.main.async { self?.reload() }
    
            case .failure(let error):
                remLog(error.localizedDescription)
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNavBarThemed(enabled: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.setNavBarThemed(enabled: false)
    }
    
    //MARK: - Overrides
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    //MARK: - Functions
    private func setupUI() {
        self.view.clipsToBounds = true
        
        /*self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.triangle.2.circlepath.circle.fill"),
                                                                   style: .plain,
                                                                   target: self,
                                                                   action: #selector(respringDevice)*/
        let bannerImageView = UIImageView(frame: headerView.bounds)
        bannerImageView.contentMode = .scaleAspectFill
        bannerImageView.image = UIImage(contentsOfFile: JailbreakTweakManager.shared.prefsAssetsPath + "/HSBanner.png")
        bannerImageView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(bannerImageView)
        
        NSLayoutConstraint.activate([
            bannerImageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: -50),
            bannerImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            bannerImageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
        ])
    }
    
    //MARK: - Actions
    /*
        The tweak no longer requires a respring to take effect when it is enabled or disabled in Preferences.
    */
    /*
    @objc func respringDevice() {
        let binaryPath = JailbreakTweakManager.shared.binPath + "killall"
        let args = ["killall", "SpringBoard", nil].map({ UnsafeMutablePointer(mutating: ($0 as? NSString)?.utf8String) })
        var pid: pid_t = 0
        
        posix_spawn(&pid, binaryPath, nil, nil, args, nil)
    }
    */
    
    //MARK: - TableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.tableHeaderView = headerView
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        switch cell {
        case is HSInfoButtonCell:
            guard let cell = cell as? HSInfoButtonCell else { return cell }
            cell.delegate = self
            
        case is HSSingleCreditCell:
            guard let cell = cell as? HSSingleCreditCell else { return cell }
            cell.delegate = self
            cell.configure(for: mainDeveloper,
                           with: UIImage(contentsOfFile: JailbreakTweakManager.shared.prefsAssetsPath + "/Credits/DefaultIcon.png"))
            
        case is HSSwitchCell:
            guard let cell = cell as? HSSwitchCell else { return cell }
            cell.delegate = self
            
        default: break
        }
        return cell
    }
}
