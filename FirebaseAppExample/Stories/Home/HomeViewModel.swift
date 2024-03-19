//
//  HomeViewModel.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit
import FirebaseAuth

final class HomeViewModel {

    // MARK: - Types

    enum ScreenState {
        case home
        case user
    }

    enum UserScreenState {
        case loginNeeded
        case userLoggedIn
    }

    // MARK: - Properties

    internal let coordinator: HomeCoordinator
    internal weak var viewController: HomeViewControllerActions?
    private let inputData: HomeInputData

    var screenState: ScreenState = .home
    var userScreenState: UserScreenState = .loginNeeded

    var imagePicker: ImagePicker?
    
    // MARK: - CellModels

    var cellModels: [CellModel] = []

    private lazy var resetPasswardCellModel: ButtonCellModel = {
        ButtonCellModel(
            title: "Resetovať heslo",
            titleTextStyle: .buttonCellTitleRed,
            subtitle: nil,
            style: .roundedTop,
            isForwardIconHidden: true
        ) { [weak self] in
            firUserService.resetPasswordForEmail(email: firUserService.userEmail) { error in
                if let error = error {
                    self?.coordinator.showAlertOneButton(
                        title: "Error",
                        message: error.localizedDescription,
                        oneButtonTitle: "OK",
                        oneButtonAction: nil
                    )
                } else {
                    self?.coordinator.showAlertCancelOrAction(
                        title: "Resetovanie hesla",
                        message: "Do vašej e-mailovej schránky\n\(firUserService.userEmail)\nsme Vám zaslali e-mail s linkom na resetovanie hesla.",
                        actionButtonTitle: "Prejsť do apky Mail",
                        actionButtonAction: {
                            if let mailURL = URL(string: "message://"), UIApplication.shared.canOpenURL(mailURL) {
                                if UIApplication.shared.canOpenURL(mailURL) {
                                    UIApplication.shared.open(mailURL)
                                }
                            }
                        }
                    )
                }
            }
        }
    }()

    private lazy var deleteAccountCellModel: ButtonCellModel = {
        ButtonCellModel(
            title: "Zrušiť účet",
            titleTextStyle: .buttonCellTitleRed,
            subtitle: nil,
            style: .roundedBottom,
            isForwardIconHidden: true
        ) { [weak self] in
            self?.coordinator.showAlertCancelOrAction(title: "Naozaj chcete zrušiť účet?", message: nil, actionButtonTitle: "Áno, zrušiť") { [weak self] in
                self?.coordinator.showAlertCancelOrAction(
                    title: "Ste si tým úplne istý?",
                    message: "Táto akcia je nevratná",
                    actionButtonTitle: "Áno, zrušiť"
                ) { [weak self] in
                    firUserService.deleteLoggedUser { [weak self] error in
                        if let error = error {
                            self?.coordinator.showAlertOneButton(
                                title: "Error",
                                message: error.localizedDescription,
                                oneButtonTitle: "OK",
                                oneButtonAction: nil
                            )
                        } else {
                            self?.updateUserState()
                        }
                    }
                }
            }
        }
    }()

    private lazy var logoutCellModel: ButtonCellModel = {
        ButtonCellModel(
            title: "Odhlásiť sa",
            titleTextStyle: .buttonCellTitleRed,
            subtitle: nil,
            style: .roundedTopAndBottom,
            isForwardIconHidden: true
        ) { [weak self] in
            self?.coordinator.showAlertCancelOrAction(
                title: "Naozaj sa chcete odhlásiť?",
                message: nil,
                actionButtonTitle: "Áno, odhlásiť"
            ) { [weak self] in
                firUserService.logoutUser()
                self?.updateUserState()
            }
        }
    }()
    
    private lazy var userCellModel: UserCellModel = {
        UserCellModel(delegate: self)
    }()

    var userCellModels: [CellModel] = []

    // MARK: - Init

    init(coordinator: HomeCoordinator, viewController: HomeViewControllerActions?, inputData: HomeInputData) {
        self.coordinator = coordinator
        self.viewController = viewController
        self.inputData = inputData

        userCellModels = [
            userCellModel,
            SpaceCellModel(height: 35),
            HeaderCellModel(title: "Moje články"),
            SpaceCellModel(height: 5),
            ButtonCellModel(title: "Aktívne", subtitle: "Zverejnené zobrazované články", style: .roundedTop),
            ButtonCellModel(title: "Čakajúce", subtitle: "Články čakajúce na schválenie", style: .standard),
            ButtonCellModel(title: "Archivované", subtitle: "Uplynulé a zrušené články", style: .roundedBottom),
            SpaceCellModel(height: 20),
            HeaderCellModel(title: "Správa účtu"),
            SpaceCellModel(height: 5),
            resetPasswardCellModel,
            deleteAccountCellModel,
            SpaceCellModel(height: 20),
            logoutCellModel
        ]
    }

    // MARK: - Lifecycle

    func viewDidLoad() {
        loadData()
    }

    // MARK: - Actions

    func plusButtonTapped() {
        if firUserService.isUserLoggedIn {
            coordinator.showNewRequest()
        } else {
            userButtonTapped()
        }
    }

    func homeButtonTapped() {
        guard screenState != .home else {
            return
        }
        screenState = .home
        viewController?.updateScreenState()
    }

    func userButtonTapped() {
        guard screenState != .user else {
            return
        }
        screenState = .user
        viewController?.updateScreenState()
        var one = 1
        var two = 2
        swap(&one, &two)
    }

    func loginButtonTapped() {
        coordinator.showSignup(mode: .login, delegate: self)
    }

    func signupButtonTapped() {
        coordinator.showSignup(mode: .signup, delegate: self)
    }

    // MARK: - Utilities

    private func swap<T>(_ first: inout T, _ second: inout T) {
        let tempFirst = first
        first = second
        second = tempFirst
    }
    
    private func loadData() {
        
        firDataService.getArticles { [weak self] error, articles in
            guard let self = self else { return }
            self.cellModels.removeAll()

            for article in articles {
                let articleModel = RequestCellModel(article: article)
                self.cellModels.append(articleModel)
            }
            
            self.viewController?.reloadCollectionView(with: self.cellModels)
        }
        
        updateUserState()
    }
}

extension HomeViewModel: CellModelDataSourceDelegate {
    func didSelect(_ collectionView: UICollectionView, cellModel: CellModel, at indexPath: IndexPath) {
        if collectionView == viewController?.collectionView {
            if let model = cellModels[indexPath.row] as? RequestCellModel, let content = model.article?.content {
                coordinator.showDetail(text: content)
            }
        }
        if collectionView == viewController?.userCollectionView {
            if let buttonCellModel = cellModel as? ButtonCellModel {
                buttonCellModel.action?()
            }
        }
    }
}

extension HomeViewModel: SignupViewModelDelegate {
    func updateUserState() {
        userScreenState = firUserService.isUserLoggedIn ? .userLoggedIn : .loginNeeded
        viewController?.updateScreenState()
        
        userCellModel.updateUserEmailLabel()
        if userScreenState == .userLoggedIn {
            userCellModel.fetchProfileImage()
        } else {
            userCellModel.setPlaceHolederProfileImage()
        }
    }
}

extension HomeViewModel: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        Logger.log(string: "Finished picking image: \(String(describing: image))", type: .all)
        if let profileImage = image {
            Logger.log(string: "Loading for image upload started", type: .all)
            self.imageLoadingDidBegin()
            firUserService.updateProfileImage(profileImage) { error, url in
                Logger.log(string: "Loading for image upload finished, success: \(error == nil)", type: .all)
                if error == nil {
                    self.updateUserCellImageFinished(image: profileImage, success: true)
                } else {
                    self.updateUserCellImageFinished(image: profileImage, success: false)
                }
            }
        }
    }
    
    func didSelectDeleteImage() {
        Logger.log(string: "Delete profile image selected", type: .all)
        self.imageLoadingDidBegin()
        firUserService.deleteProfileImageForCurrentUser { error in
            Logger.log(string: "Delete profile image finished success: \(error == nil)", type: .all)
            if error == nil {
                // TODO: delete picture URL from user here
                self.deleteUserCellImageFinished(success: true)
            } else {
                self.deleteUserCellImageFinished(success: false)
            }
        }
    }
    
    // MARK: - Helpers
    
    func deleteUserCellImageFinished(success: Bool) {
        if let userCellModel = userCellModels.first as? UserCellModel {
            userCellModel.deleteCellImageFinished(success: success)
        }
    }
    
    func updateUserCellImageFinished(image: UIImage, success: Bool) {
        if let userCellModel = userCellModels.first as? UserCellModel {
            userCellModel.updateCellImageFinished(image: image, success: success)
        }
    }
    
    func imageLoadingDidBegin() {
        if let userCellModel = userCellModels.first as? UserCellModel {
            userCellModel.setIsLoading(isLoading: true)
        }
    }
}
