To make an Oxygen Framework

-find current framework (see location below)
-edit as needed
-zip the file (change name accordingly)
     zip -r IIP-forms2017.1j.zip IIP2017.1j -x "*.DS_Store"
-Edit the file with the extensions information. in this case iip_authoring.xml
-copy iip_authoring.xml and zip file to extensions directory. In this case 
     http://cds.library.brown.edu/projects/iip/??
     
     scp emylonas@pcdscit.services.brown.edu:/var/www/html/projects/iip/oxygen-addons

Useful info:
Frameworks as extensions are in ~/Library/Preferences/com.oxygenxml/extensions
