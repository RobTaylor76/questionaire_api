SymmetricEncryption.cipher = SymmetricEncryption::Cipher.new(
    key: Rails.application.credentials.symmetric_encryption_key,
    version: Rails.application.credentials.symmetric_encryption_key_version,
    cipher_name: 'aes-256-cbc',
    always_add_header: true)
