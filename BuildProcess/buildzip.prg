lcFiles = '..\Source\AWSSDK.Core.dll,..\Source\AWSSDK.S3.dll,' + ;
	'..\Source\Document.dll,..\Source\Document.vct,' + ;
	'..\Source\Document.vcx'
loZIP = newobject('VFPXZip', 'VFPXZip.prg')
loZIP.Zip(lcFiles, '..\FoxGet\Source.zip', .T.)
if empty(loZIP.cErrorMessage)
	messagebox('Source.zip created')
else
	messagebox(loZIP.cErrorMessage)
endif empty(loZIP.cErrorMessage)
