//
//  DecryptionManager.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 23/10/21.
//  Copyright © 2021 Raúl Montón Pinillos. All rights reserved.
//

import Firebase
import Foundation
import CryptoKit
import UIKit

class DecryptionManager {

    private var decryptionKey: SymmetricKey?

    init?() {
        initializeDecryptionKey()
    }

    // MARK: - Public functions
    public func getDecryptedImageData(filename: String) -> Data? {

        // Check for decryption key
        guard let decryptionKey = decryptionKey else {
            return nil
        }

        // Try to locate the resource URL
        guard let imageURL = Bundle.main.url(forResource: filename, withExtension: "jpg") else {
            return nil
        }

        // Get the encrypted image data
        let encryptedImageData = FileManager.default.contents(atPath: imageURL.path)

        // Create the sealed box from the encrypted image data
        let sealedBox = try! ChaChaPoly.SealedBox(combined: encryptedImageData!)

        // Decrypt the content
        guard let decryptedData = try? ChaChaPoly.open(sealedBox, using: decryptionKey) else {
            NSLog("Decrypting image failed.")
            return nil
        }

        return decryptedData
    }

    // MARK: - Private functions


    private func initializeDecryptionKey() {

        // Retrieve the decryption key reference from the Firebase database
        let decryptionKeyNode = Database.database().reference().child("PhotoEncryptionKey")

        // Keep decryption key synced
        decryptionKeyNode.keepSynced(true)

        // Retreieve the key value
        decryptionKeyNode.observeSingleEvent(of: .value, with: { snapshot in

            guard let password = snapshot.value as? String else {
                return
            }

            // Add padding to password to match the required 256 bits
            let paddedPassword = password.padding(toLength: 32, withPad: "@", startingAt: 0)

            // Create the symmetric key from the plaintext password
            self.decryptionKey = SymmetricKey(data: paddedPassword.data(using: String.Encoding.utf8)!)
        })
    }
}

extension UIImage {
    convenience init?(encryptedFilename: String) {
        let decryptionManager = AppState.shared.decryptionManager
        let decryptedData = decryptionManager?.getDecryptedImageData(filename: encryptedFilename)
        guard let decryptedData = decryptedData else {
            return nil
        }
        self.init(data: decryptedData)
    }
}
