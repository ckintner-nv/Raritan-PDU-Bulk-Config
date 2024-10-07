# Raritan-PDU-Bulk-Config
A bash script that pushes config files to a list of IPs.

1. Configure one PDU, and download that configuration file in cleartext. This will be pushed to all the target PDUs. The file should be named "bulk_config_cleartext.txt"
2. Ensure all target PDUs use the same password. The default password for Raritan PDUs is "raritan". I have not tested it with this password, but logging in with the defaults will force a password change
3. Update the pduips.txt file to include all the target IPs
4. Install sshpass
5. Run the script

SSHpass is used, so there's a password confirmation script included, so as to not store passwords in plaintext.
