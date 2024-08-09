[private]
default:
    @just --list

# Run linter
lint:
    yamllint .
    actionlint
    ansible-lint

# Edit vault file
edit-vault:
    ansible-vault edit --vault-password-file $HOME/.ansible-vault/vault.secret group_vars/all/vault.yml

# Encrypt file
encrypt-file file='' name='':
    cat {{file}} | ansible-vault encrypt_string --vault-password-file $HOME/.ansible-vault/vault.secret --stdin-name "{{name}}"

# Encrypt string
encrypt-string string='' name='':
    ansible-vault encrypt_string --vault-password-file $HOME/.ansible-vault/vault.secret "{{string}}" --name "{{name}}"
