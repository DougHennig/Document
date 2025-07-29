# Document

[![ChangeLog](https://img.shields.io/github/last-commit/DougHennig/Document?path=ChangeLog.md&label=Latest%20Release)](ChangeLog.md)

Many applications generate or reference documents: purchase orders, invoices, product documentation, lab results, and so on. Some applications manage them by storing them in a database, such as in a Blob column. There are some advantages to that, such as avoiding issues with files becoming overwritten, corrupted, stolen, or deleted, but the database can become very large and cumbersome to work with. Other applications store the documents in a file system, such as a server volume. That's fine but when there are thousands of documents consuming many GB of space, tasks like backup and restore become time-consuming.

[Amazon Simple Storage Service (S3)](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html) is an object storage service that's part of the Amazon Web Services (AWS) stack. It's [inexpensive](https://aws.amazon.com/s3/pricing): about $0.02 per GB per month. There is also a free tier: a 12-month trial that provides 5 GB of storage at no cost.

Managing documents in S3 requires using the S3 API, which is difficult to do in VFP. Fortunately, the Document class makes it easy. You can either download it from here or install it using [FoxGet](https://github.com/DougHennig/FoxGet) (a package manager project for VFP).

See the [documentation](Documentation/Document.md) for details on how to use this project.

## Sample

The Samples folder has a sample form that demonstrates the use of the Document class. It uses the TestData sample database that comes with VFP for entities (customers, orders, order details, and products). To use this sample, do the following:

* Create and set up an S3 account as described in [AmazonS3.md](Documentation/AmazonS3.md).

* Create the sample document tables. If you want to use DBFs, run CreateTablesDBF.prg (the tables are created as free tables). If you want to use SQL Server, edit CreateTablesSQL.prg as noted in the TODO comments and then run it.

* If you used SQL Server in the previous step, uncomment the code in the Load method of Orders.scx and edit the SQLSTRINGCONNECT statement as noted in the comments. Also, uncomment the code in the Destroy method.

* Run Orders.scx. The first time you run it, you will be prompted for the S3 access key ID, secret access key, bucket name, and region name for your S3 account. These values are saved in Settings.ini (the first two are encrypted) so they are used the next time you run the form.

* Select an order in the Orders tab, then select the Order Information tab and click one of the buttons (Picking List, Packing Slip, or Invoice) to create a PDF file and upload it to S3. Note that the form uses the Microsoft Print to PDF printer driver for demo purposes but in a real application would use something like XFRX or FoxyPreviewer to create a PDF. The name of the file to create is placed on the clipboard so when the Save dialog appears to create the PDF file, paste the filename into the dialog.

* After creating one or more documents for an order, select the Documents tab to see a list of documents. Select one and click View to download it from S3 and view it in your default PDF viewer. Click Add to display a form to manually add a document or remove to remove the selected document.

