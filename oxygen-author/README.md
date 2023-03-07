## To make an Oxygen Framework

Frameworks are in the usep-data repository, in the folder called `oxygen-author`.
1. Copy the most recent `usep-forms` directory and increase the version number. 
1. Make whatever changes or updates are necessary to the framework. 
1. Zip the files using the following unix command, changing zip file name and framework directory name accordingly.
     `zip -r usep-forms2.8.zip usep-forms2.8 -x "*.DS_Store"`
1. Edit the file with the extensions information: `usep-addon.xml`. 
   1.  Copy the most recent `<xt:extension>` element and paste it at the end of the file, inside the `<xt:extensions>` element.
    1. Change file name in `<xt:location>`
    1. Update the version number in `<xt:version>`
    1. Update the title information
    1. Add a note explaining what has changed. 

This should be sufficient to trigger an update . 
 

### Useful info:
In order to test without having to keep updating the framework and triggering updates for everyone using the framework, it is possible to copy  or edit the working framework directly. Addon frameworks are stored in `~/Library/Preferences/com.oxygenxml/extensions`

