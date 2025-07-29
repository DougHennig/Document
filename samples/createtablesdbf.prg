create table Documents free ;
	(DocumentID int autoinc, ;
	DocTypeID int, ;
	Path M, ;
	Descrip C(80), ;
	FileKey C(200), ;
	Comments M, ;
	FileDate T, ;
	CreatedOn T)
index on DocumentID tag DocumentID
index on DocTypeID  tag DocTypeID

create table DocumentTypes free ;
	(DocTypeID int autoinc, ;
	Name C(50), ;
	S3Folder C(50), ;
	Entity C(40), ;
	Field C(40))
index on DocTypeID tag DocTypeID
insert into DocumentTypes ;
		(Name, ;
		S3Folder, ;
		Entity, ;
		Field) ;
	values ;
		('Customer Document', ;
		'CustDocs', ;
		'CustomerDocuments', ;
		'Cust_ID')
insert into DocumentTypes ;
		(Name, ;
		S3Folder, ;
		Entity, ;
		Field) ;
	values ;
		('Purchase Order', ;
		'OrdDocs', ;
		'OrderDocuments', ;
		'Order_ID')
insert into DocumentTypes ;
		(Name, ;
		S3Folder, ;
		Entity, ;
		Field) ;
	values ;
		('Order Confirmation', ;
		'OrdDocs', ;
		'OrderDocuments', ;
		'Order_ID')
insert into DocumentTypes ;
		(Name, ;
		S3Folder, ;
		Entity, ;
		Field) ;
	values ;
		('Picking List', ;
		'OrdDocs', ;
		'OrderDocuments', ;
		'Order_ID')
insert into DocumentTypes ;
		(Name, ;
		S3Folder, ;
		Entity, ;
		Field) ;
	values ;
		('Packing Slip', ;
		'Orders', ;
		'OrderDocuments', ;
		'Order_ID')
insert into DocumentTypes ;
		(Name, ;
		S3Folder, ;
		Entity, ;
		Field) ;
	values ;
		('Invoice', ;
		'OrdDocs', ;
		'OrderDocuments', ;
		'Order_ID')

create table CustomerDocuments free ;
	(CustDocID int autoinc, ;
	Cust_ID C(6), ;
	DocumentID int, ;
	CreatedOn T)
index on Cust_ID    tag Cust_ID
index on DocumentID tag DocumentID
index on CustDocID  tag CustDocID

create table OrderDocuments free ;
	(OrderDocID int autoinc, ;
	Order_ID C(6), ;
	DocumentID int, ;
	CreatedOn T)
index on Order_ID   tag Order_ID
index on DocumentID tag DocumentID
index on OrderDocID tag OrderDocID
