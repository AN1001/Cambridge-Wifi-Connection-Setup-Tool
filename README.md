# Cambridge-Wifi-Connection-Setup-Tool
A guide to connect to eduroam on Linux at Cambridge. May not work for all distos. I created this because the installer in the uni guide looks painful. This works but it might not be safe, use at your own risk. This should work for all distros using iwd, just make sure `/etc/ssl/certs/DigiCert_Global_Root_G2.pem` exists on yours i.e. it comes pre installed.
Also other users on the same device may be able to see your credentials, you may want to edit file permissions for the file below if you don't want this to occur.

This assumes you have already made a network access token, if not go to: https://tokens.uis.cam.ac.uk/

# Manual Connection
- Run `sudo nano /var/lib/iwd/eduroam.8021x`
- Paste in (replacing username and password with your own - the credentials given are just demo btw)
  ```
  [Security]
  EAP-Method=PEAP
  EAP-Identity=_pub@cam.ac.uk
  EAP-PEAP-Phase2-Method=MSCHAPV2
  EAP-PEAP-Phase2-Identity=tt554+pc@cam.ac.uk
  EAP-PEAP-Phase2-Password=huioq0gkyzs3zg3r
  EAP-PEAP-CACert=/etc/ssl/certs/DigiCert_Global_Root_G2.pem
  EAP-PEAP-ServerDomainMask=token-public.wireless.cam.ac.uk
  
  [Settings]
  AutoConnect=true
  ```
- Save and exit
- That should be it but if it doesn't auto connect you can use iwctl to manually connect

# Automatic Script to connect
### Warning
This was vibe coded to follow the above steps, use at your own risk, verify yourself that this script is safe to run.

### Setup

- Connect to UniOfCam-Guest temporarily and download the `setup_eduroam.sh` file
- Then `chmod +x setup_eduroam.sh`
- Then `sudo ./setup_eduroam.sh` (replace path with where you stored file) or just run file however you want
