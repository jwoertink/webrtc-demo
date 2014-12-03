## Making changes

Edit the `attributes/default.rb` to change the version or other settings

## Issues
* The keys needs for TLS don't get generated properly. See generating keys below after installation.

### Generating Asterisk keys
1. `mkdir /etc/asterisk/keys`
2. cd `/usr/local/src/asterisk*/contrib/scripts`
3. `./ast_tls_cert -C YOUR_VM_HOSTNAME -O "YOUR_ASTERISK_BOX_NAME" -d /etc/asterisk/keys` important: don't add the trailing slash to the keys directory (i.e. with tab autocomplete).
4. Follow directions
