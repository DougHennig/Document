using System;
using System.IO;
using System.Web;
using Amazon;
using Amazon.S3;
using Amazon.S3.Model;
using Amazon.S3.Transfer;
using Document.Helpers;

namespace Document
{
    public class S3Document
    {
        // Constructor: optionally set the properties.
        public S3Document(string accessKeyId = null, string secretAccessKey = null, string bucketName = null, string region = null)
        {
            AccessKeyID = string.IsNullOrWhiteSpace(accessKeyId) ? "" : accessKeyId;
            SecretAccessKey = string.IsNullOrWhiteSpace(secretAccessKey) ? "" : secretAccessKey;
            BucketName = string.IsNullOrWhiteSpace(bucketName) ? "" : bucketName;
            Region = string.IsNullOrWhiteSpace(region) ? "" : region;
        }

        #region Public properties
        public string ErrorMessage { get; private set; }
        public string AccessKeyID { get; set; }
        public string SecretAccessKey { get; set; }
        public string BucketName { get; set; }
        public string Region { get; set; }
        #endregion

        #region Constants
        private const long PartSize = 1024 * 1024 * 10; // 10 MB
        #endregion

        #region Public methods
        // Uploads a file to Amazon S3.
        public bool Create(string key, string filePath)
        {
            bool returnValue;
            ErrorMessage = "";

            try
            {
                // Basic parameter validation.
                if (string.IsNullOrWhiteSpace(key))
                    throw new ArgumentException("Key is blank");

                if (string.IsNullOrWhiteSpace(filePath))
                    throw new ArgumentException("File path is blank");

                if (!File.Exists(filePath))
                    throw new ArgumentException("File path not found");

                // S3
                var region = GetRegionEndpoint(Region);
                string extension = Path.GetExtension(filePath);

                using (var trxUtility = new TransferUtility(AccessKeyID, SecretAccessKey, region))
                {
                    var uploadRequest = new TransferUtilityUploadRequest
                    {
                        BucketName = BucketName,
                        CannedACL = S3CannedACL.BucketOwnerFullControl,
                        ContentType = GetContentType(extension),
                        FilePath = filePath,
                        Key = key,
                        PartSize = PartSize,
                        ServerSideEncryptionMethod = ServerSideEncryptionMethod.None,
                        StorageClass = S3StorageClass.Standard,
                    };

                    trxUtility.UploadAsync(uploadRequest).Wait();
                }
                returnValue = true;
            }
            catch (Exception ex)
            {
                returnValue = false;
                ErrorMessage = ex.GetExceptionMessages();
            }

            return returnValue;
        }

        // Deletes file(s) from Amazon S3.
        public bool Delete(string key)
        {
            bool returnValue;
            ErrorMessage = "";

            try
            {
                // Basic parameter validation.
                if (string.IsNullOrWhiteSpace(key))
                    throw new ArgumentException("Key is blank");

                // S3
                var region = GetRegionEndpoint(Region);

                using (var s3Client = new AmazonS3Client(AccessKeyID, SecretAccessKey, region))
                {
                    // Initialize the ListVersions Request and Response.
                    var lvRequest = new ListVersionsRequest()
                    {
                        BucketName = BucketName,
                        Prefix = key,
                    };

                    ListVersionsResponse lvResponse;

                    // Initialize the DeleteObjects Request and Response.
                    var doRequest = new DeleteObjectsRequest()
                    {
                        BucketName = BucketName,
                    };

                    // ListVersions returns a max of 1000, DeleteObjects has a limit of 1000.
                    do
                    {
                        lvResponse = s3Client.ListVersions(lvRequest);

                        if (lvResponse.Versions.Count > 0)
                        {
                            foreach (var s3ov in lvResponse.Versions)
                            {
                                doRequest.AddKey(s3ov.Key, s3ov.VersionId);

                                if (doRequest.Objects.Count > 999)
                                {
                                    s3Client.DeleteObjectsAsync(doRequest).Wait();
                                    doRequest.Objects.Clear();
                                }
                            }
                        }

                        lvRequest.KeyMarker = lvResponse.NextKeyMarker;
                        lvRequest.VersionIdMarker = lvResponse.NextVersionIdMarker;

                    } while (lvResponse.IsTruncated);

                    if (doRequest.Objects.Count > 0)
                        s3Client.DeleteObjectsAsync(doRequest).Wait();
                }
                returnValue = true;
            }
            catch (Exception ex)
            {
                returnValue = false;
                ErrorMessage = ex.GetExceptionMessages();
            }

            return returnValue;
        }

        // Downloads a file from Amazon S3.
        public bool Get(string key, string filePath)
        {
            bool returnValue;
            ErrorMessage = "";

            try
            {
                // Basic parameter validation.
                if (string.IsNullOrWhiteSpace(key))
                    throw new ArgumentException("Key is blank");

                if (string.IsNullOrWhiteSpace(filePath))
                    throw new ArgumentException("File path is blank");

                // S3
                var region = GetRegionEndpoint(Region);

                using (var s3Client = new AmazonS3Client(AccessKeyID, SecretAccessKey, region))
                {
                    var request = new GetObjectRequest
                    {
                        BucketName = BucketName,
                        Key = key
                    };

                    var response = s3Client.GetObject(request);

                    response.WriteResponseStreamToFile(filePath);
                }
                returnValue = true;
            }
            catch (Exception ex)
            {
                returnValue = false;
                ErrorMessage = ex.GetExceptionMessages();
                if (ErrorMessage.Contains("(404)"))
                {
                    ErrorMessage = ex.Message;
                }
            }

            return returnValue;
        }
        #endregion

        #region Private methods
        private static string GetContentType(string inputExtension)
        {
            if (string.IsNullOrWhiteSpace(inputExtension))
                return null;

            return MimeMapping.GetMimeMapping(inputExtension);
        }

        private static RegionEndpoint GetRegionEndpoint(string inputRegion)
        {
            return RegionEndpoint.GetBySystemName(inputRegion);
        }
        #endregion
    }
}
