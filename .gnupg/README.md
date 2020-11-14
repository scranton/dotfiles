# Using GPG

A quick outline of what must be done to get everything working.

## Step 1: Update the Permissions on your ~/.gnupg Directory

You will need to modify the permissions to 700 to secure this directory.  

    chmod 700 ~/.gnupg

## Step 2: Create your GPG Key

Run the following command to generate your key, note we have to use the `--expert` flag so as to generate a 4096-bit key.

    gpg --full-generate-key

## Step 3: Answer the Questions

Once you have entered your options, pinentry will prompt you for a password for the new PGP key.

    Please select what kind of key you want:
       (1) RSA and RSA (default)
       (2) DSA and Elgamal
       (3) DSA (sign only)
       (4) RSA (sign only)
    Your selection? 4
    RSA keys may be between 1024 and 4096 bits long.
    What keysize do you want? (2048) 4096
    Requested keysize is 4096 bits
    Please specify how long the key should be valid.
             0 = key does not expire
          <n>  = key expires in n days
          <n>w = key expires in n weeks
          <n>m = key expires in n months
          <n>y = key expires in n years
    Key is valid for? (0) 3y
    Key does not expire at all
    Is this correct? (y/N) y

    You need a user ID to identify your key; the software constructs the user ID
    from the Real Name, Comment and Email Address in this form:
        "Scott Cranton () <my@email.com>"

    Real name: Scott Cranton
    Email address: my@email.com
    Comment:
    You selected this USER-ID:
        "Scott Cranton <my@email.com>"

    Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? o
    You need a Passphrase to protect your secret key.

## Step 4: Get your key info for Git, etc

    # List your keys
    gpg -k

## Step 5: Get your key id

Use the next command to generate a short form of the key fingerprint.

Copy the text after the `rsa4096/` and before the date generated and use the copied id in step 7:  

    gpg -K --keyid-format SHORT
    sec rsa4096/######## YYYY-MM-DD [SC] [expires: YYYY-MM-DD]

*You need to copy the output similar to the example above where the ######## is.*

## Step 6: Configure Git to use gpg

    git config --global gpg.program $(which gpg)

## Step 7: Configure Git to use your signing key

The below command needs the fingerprint from step 10 above:  

    git config --global user.signingkey ########

## Step 8: Configure Git to sign all commits (Optional-you can configure this per repository too)

This tells Git to sign all commits using the key you specified in step 13.  

    git config --global commit.gpgsign true

## Step 9: Export the fingerprint

In the output from step 10, the line below the row that says 'pub' shows a fingerprint - this is what you use in the `<your key id>` placeholder. The output from below is what you copy to Github:  

    # The export command below gives you the key you add to GitHub
    gpg --armor --export <your key id>

## Step 10: Submit your PGP key to Github to verify your Commits

Open <https://github.com/settings/keys> go to your settings, SSH and GPG Keys, and add your GPG key from the page.

## Step 11: Perform a Commit

    git commit -S -s -m "My Signed Commit"

## Step 12: Pinentry Prompt

You will now be prompted by Pinentry for the password for your signing key.  You can enter it into the Dialog box-with the option of saving the password to the macOS X Keychain.

## Troubleshooting

If you have any errors when generating a key regarding gpg-agent, try the following command to see what error it generates:  

    gpg-agent --daemon
