*** TODO: change the database name as necessary
lcDatabase = 'Documents'

*** TODO: change the server and credentials as necessary
lnHandle = sqlstringconnect('driver=SQL Server;' + ;
	'server=dhennig-dell;' + ;
	'trusted_connection=yes')
if lnHandle < 0
	aerror(laError)
	messagebox(laError[3])
	return
endif lnHandle < 0

*** TODO: add any other clauses to the CREATE DATABASE command as desired
text to lcSQL noshow textmerge
create database <<lcDatabase>>
endtext
llResult = sqlexec(lnHandle, lcSQL) > 0
if not llResult
	aerror(laError)
	sqldisconnect(lnHandle)
	messagebox(laError[3])
	return
endif not llResult

* Note: we use varchar(4096) rather than varchar(max) because there's an issue
* with the SQL Server driver: it returns C(0) for varchar(max) columns. That's
* fixed if you use VFP Advanced.
text to lcSQL noshow textmerge
create table <<lcDatabase>>.dbo.Documents
	(DocumentID int identity(1, 1) primary key,
	DocTypeID int,
	Path varchar(240),
	Descrip varchar(80),
	FileKey varchar(200),
	Comments varchar(4096),
	FileDate datetime,
	CreatedOn datetime)
endtext
llResult = sqlexec(lnHandle, lcSQL) > 0
if not llResult
	aerror(laError)
	sqldisconnect(lnHandle)
	messagebox(laError[3])
	return
endif not llResult

text to lcSQL noshow textmerge
create table <<lcDatabase>>.dbo.DocumentTypes
	(DocTypeID int identity(1, 1) primary key,
	Name varchar(50),
	S3Folder varchar(50),
	Entity varchar(40),
	Field varchar(40))
endtext
llResult = sqlexec(lnHandle, lcSQL) > 0
if not llResult
	aerror(laError)
	sqldisconnect(lnHandle)
	messagebox(laError[3])
	return
endif not llResult

text to lcSQL noshow textmerge
insert into <<lcDatabase>>.dbo.DocumentTypes
		(Name,
		S3Folder,
		Entity,
		Field)
	values
		('Customer Document',
		'CustDocs',
		'CustomerDocuments',
		'Cust_ID')
endtext
llResult = sqlexec(lnHandle, lcSQL) > 0
if not llResult
	aerror(laError)
	sqldisconnect(lnHandle)
	messagebox(laError[3])
	return
endif not llResult

text to lcSQL noshow textmerge
insert into <<lcDatabase>>.dbo.DocumentTypes
		(Name,
		S3Folder,
		Entity,
		Field)
	values
		('Purchase Order',
		'OrdDocs',
		'OrderDocuments',
		'Order_ID')
endtext
llResult = sqlexec(lnHandle, lcSQL) > 0
if not llResult
	aerror(laError)
	sqldisconnect(lnHandle)
	messagebox(laError[3])
	return
endif not llResult

text to lcSQL noshow textmerge
insert into <<lcDatabase>>.dbo.DocumentTypes
		(Name,
		S3Folder,
		Entity,
		Field)
	values
		('Order Confirmation',
		'OrdDocs',
		'OrderDocuments',
		'Order_ID')
endtext
llResult = sqlexec(lnHandle, lcSQL) > 0
if not llResult
	aerror(laError)
	sqldisconnect(lnHandle)
	messagebox(laError[3])
	return
endif not llResult

text to lcSQL noshow textmerge
insert into <<lcDatabase>>.dbo.DocumentTypes
		(Name,
		S3Folder,
		Entity,
		Field)
	values
		('Picking List',
		'OrdDocs',
		'OrderDocuments',
		'Order_ID')
endtext
llResult = sqlexec(lnHandle, lcSQL) > 0
if not llResult
	aerror(laError)
	sqldisconnect(lnHandle)
	messagebox(laError[3])
	return
endif not llResult

text to lcSQL noshow textmerge
insert into <<lcDatabase>>.dbo.DocumentTypes
		(Name,
		S3Folder,
		Entity,
		Field)
	values
		('Packing Slip',
		'Orders',
		'OrderDocuments',
		'Order_ID')
endtext
llResult = sqlexec(lnHandle, lcSQL) > 0
if not llResult
	aerror(laError)
	sqldisconnect(lnHandle)
	messagebox(laError[3])
	return
endif not llResult

text to lcSQL noshow textmerge
insert into <<lcDatabase>>.dbo.DocumentTypes
		(Name,
		S3Folder,
		Entity,
		Field)
	values
		('Invoice',
		'OrdDocs',
		'OrderDocuments',
		'Order_ID')
endtext
llResult = sqlexec(lnHandle, lcSQL) > 0
if not llResult
	aerror(laError)
	sqldisconnect(lnHandle)
	messagebox(laError[3])
	return
endif not llResult

text to lcSQL noshow textmerge
create table <<lcDatabase>>.dbo.CustomerDocuments
	(CustDocID int identity(1, 1) primary key,
	Cust_ID varchar(6),
	DocumentID int,
	CreatedOn datetime)
endtext
llResult = sqlexec(lnHandle, lcSQL) > 0
if not llResult
	aerror(laError)
	sqldisconnect(lnHandle)
	messagebox(laError[3])
	return
endif not llResult

text to lcSQL noshow textmerge
create table <<lcDatabase>>.dbo.OrderDocuments
	(OrderDocID int identity(1, 1) primary key,
	Order_ID varchar(6),
	DocumentID int,
	CreatedOn datetime)
endtext
llResult = sqlexec(lnHandle, lcSQL) > 0
if not llResult
	aerror(laError)
	sqldisconnect(lnHandle)
	messagebox(laError[3])
	return
endif not llResult
