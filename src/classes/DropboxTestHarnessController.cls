/**
 * Copyright (c) 2014, FinancialForce.com, inc
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, 
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice, 
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, 
 *      this list of conditions and the following disclaimer in the documentation 
 *      and/or other materials provided with the distribution.
 * - Neither the name of the FinancialForce.com, inc nor the names of its contributors 
 *      may be used to endorse or promote products derived from this software without 
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
 *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

/**
 * DropboxTestHarnessController
 * 
 * Controller class for testing all the Dropbox API calls.
 */
public with sharing class DropboxTestHarnessController
{
	//statics
	//Chunk size for uploading files.
	public static final Integer CHUNK_SIZE = 2500000;
	
	//Instance variables
	public ConnectorService connectorService;
	public Boolean validConnector { get; set; }
    
   	//Dropbox account requests
   	public String dropboxAccountInfoRequestLocale { get; set; }
   
   	//Dropbox file requests
   	public String dropboxFilesGetRequestPath { get; set; }
   	public String dropboxFilesGetRequestRev { get; set; }
   	
   	public String dropboxFilesPutRequestPath { get; set; }
	public String dropboxFilesPutRequestLocale { get; set; }
	public Boolean dropboxFilesPutRequestOverwrite { get; set; }
	public String dropboxFilesPutRequestParentRev { get; set; }
	public Boolean dropboxFilesPutRequestAutorename { get; set; }
	public String dropboxFilesPutRequestContentType { get; set; }
	
	public transient Blob dropboxFilesPutRequestFileBody { get; set; }
   	
   	public String dropboxMetadataRequestPath { get; set; }
   	public Integer dropboxMetadataRequestFileLimit { get; set; }
   	public String dropboxMetadataRequestHash { get; set; }
   	public Boolean dropboxMetadataRequestList { get; set; }
   	public Boolean dropboxMetadataRequestIncludeDeleted { get; set; }
   	public String dropboxMetadataRequestRev { get; set; }
   	public String dropboxMetadataRequestLocale { get; set; }
   	public Boolean dropboxMetadataRequestIncludeMediaInfo { get; set; }
   	
   	public String dropboxDeltaRequestCursor { get; set; }
	public String dropboxDeltaRequestLocale { get; set; }
	public String dropboxDeltaRequestPathPrefix { get; set; }
	public Boolean dropboxDeltaRequestIncludeMediaInfo { get; set; }
	
	public String dropboxDeltaLatestCursorRequestPathPrefix { get; set; }
  	public Boolean dropboxDeltaLatestCursorRequestIncludeMediaInfo { get; set; }
						
	public String dropboxLongpollDeltaRequestCursor { get; set; }
  	public Integer dropboxLongpollDeltaRequestTimeout { get; set; }
   	
   	public String dropboxRevisionsRequestPath { get; set; }
   	public Integer dropboxRevisionsRequestRevLimit { get; set; }
	public String dropboxRevisionsRequestLocale { get; set; }
							
   	public String dropboxRestoreRequestPath { get; set; }
   	public String dropboxRestoreRequestRev { get; set; }
   	public String dropboxRestoreRequestLocale { get; set; }
							
   	public String dropboxSearchRequestPath { get; set; }
   	public String dropboxSearchRequestQuery { get; set; }
   	public Integer dropboxSearchRequestFileLimit { get; set; }
   	public Boolean dropboxSearchRequestIncludeDeleted { get; set; }
   	public String dropboxSearchRequestLocale { get; set; }
   	
   	public String dropboxSharesRequestPath { get; set; }
   	public String dropboxSharesRequestLocale { get; set; }
   	public Boolean dropboxSharesRequestShortUrl { get; set; }
   	
   	public String dropboxMediaRequestPath { get; set; }
   	public String dropboxMediaRequestLocale { get; set; }
   	
   	public String dropboxCopyRefRequestPath { get; set; }
   	
   	public String dropboxThumbnailsRequestPath  { get; set; }
	public String dropboxThumbnailsRequestFormat  { get; set; }
	public String dropboxThumbnailsRequestSize { get; set; }
							
  	public String dropboxPreviewsRequestPath { get; set; }
	public String dropboxPreviewsRequestRev { get; set; }
	
	public String dropboxChunkedUploadRequestContentType { get; set; }
	public transient Blob dropboxChunkedUploadRequestFileBody { get; set; }
	
	public String dropboxCommitChunkedUploadRequestUploadId { get; set; }
	public String dropboxCommitChunkedUploadRequestPath { get; set; }
	public String dropboxCommitChunkedUploadRequestLocale { get; set; }
	public Boolean dropboxCommitChunkedUploadRequestOverwrite { get; set; }
	public String dropboxCommitChunkedUploadRequestParentRev { get; set; }
	public Boolean dropboxCommitChunkedUploadRequestAutorename { get; set; }
	  
   	//Dropbox file operation requests
   	public String dropboxCopyRequestRoot { get; set; }
   	public String dropboxCopyRequestToPath { get; set; }
	public String dropboxCopyRequestFromPath { get; set; }
	public String dropboxCopyRequestFromCopyRef { get; set; }
	public String dropboxCopyRequestLocale { get; set; }
	
   	public String dropboxCreateFolderRequestRoot { get; set; }
	public String dropboxCreateFolderRequestPath { get; set; }
	public String dropboxCreateFolderRequestLocale { get; set; }
	
	public String dropboxDeleteRequestLocale { get; set; }
	public String dropboxDeleteRequestRoot { get; set; }
	public String dropboxDeleteRequestPath { get; set; }
	
	public String dropboxMoveRequestRoot { get; set; }
	public String dropboxMoveRequestFromPath { get; set; }
	public String dropboxMoveRequestToPath { get; set; }
	public String dropboxMoveRequestLocale { get; set; }
   	
    /**
     * Constructors
     */
    public DropboxTestHarnessController()
    {
        this.connectorService = getConnectorService();
        this.init();
    }
    
    private void init()
   	{
        if (connectorService != null)
        {
        	String msg = connectorService.validateConnector();
        	validConnector = String.isEmpty(msg);
        	if (!validConnector)
        	{
        		error(msg);
        	}
        	else
        	{
        		info('Successful authentication. The \'' + connectorService.Connector.Name + '\' connector is being used for authentication.');
        	}
        }
        else
        {
        	error('Dropbox connector not found.');
        }
   	}
   
    /**
     * Gets a valid connector for Dropbox requests.
     *
     * Note: for separation of concerns consider using a selector pattern.
	 * See https://developer.salesforce.com/page/Apex_Enterprise_Patterns_-_Selector_Layer
     */
    public ConnectorService getConnectorService()
    {
    	if (connectorService == null)
    	{	
    		try
    		{
	    		Connector__c c = 
	    		[
	    			SELECT 
	    				c.TokenType__c, c.RefreshToken__c, c.RefreshTokenRequested__c, c.Name, c.Id, c.AccessToken__c, 
					   	c.AccessTokenRequested__c, c.AccessTokenExpiry__c, c.Active__c, 
					   	ConnectorType__r.TokenEndpoint__c, ConnectorType__r.Scope__c, ConnectorType__r.ScopeRequired__c, 
					   	ConnectorType__r.RedirectUri__c, ConnectorType__r.Name, ConnectorType__r.Id, 
					   	ConnectorType__r.ExtraUrlParameters__c, ConnectorType__r.DeveloperName__c, 
					   	ConnectorType__r.ClientSecret__c, ConnectorType__r.ClientId__c, ConnectorType__r.CallbackURL__c, 
					   	ConnectorType__r.AuthorizationEndpoint__c
	    			FROM Connector__c c
	    			WHERE ConnectorType__r.Name =: DropboxConfigure.DROPBOX_TYPE_LABEL
	    			AND c.OwnerId =: UserInfo.getUserID()
	    			LIMIT 1
	    		];
	    		
	    		if (c != null)
	    		{
	    			connectorService = new ConnectorService(c);
	    		}
    		}
    		catch (Exception ex)
    		{
    		}
    	}
    	return connectorService;
    }
    
    /**
     * Account requests
     */
    public void dropboxAccountInfoRequest()
  	{
  		ffhttp_DropboxAccounts dropboxAccounts = createDropboxAccounts();
  		if (dropboxAccounts == null)
  		{
  			return;
  		}
  		
  		ffhttp_DropboxAccounts.InfoRequest request = dropboxAccounts.infoRequest();
  		
  		if (!String.isEmpty(dropboxAccountInfoRequestLocale))
  		{
  			request.setLocale(dropboxAccountInfoRequestLocale);
  		}
  		
  		execute(request);
  	}
  	
  	private ffhttp_DropboxAccounts createDropboxAccounts()
  	{
  		ffhttp_Dropbox db = getDropboxClient();
  		if (db == null)
    	{
    		return null;
    	}
    	
     	return db.accounts();   
  	}
  	
  	/**
  	 * Files requests
  	 */
  	public PageReference dropboxFilesGetRequest()
  	{
  		ffhttp_DropboxFiles dropboxFiles = createDropboxFiles();
  		if (dropboxFiles == null)
  		{
  			return null;
  		}
  		
  		ffhttp_DropboxFiles.FilesRequest request = dropboxFiles.filesRequest(dropboxFilesGetRequestPath);
  		
  		if (!String.isEmpty(dropboxFilesGetRequestRev))
  		{
  			request.setRev(dropboxFilesGetRequestRev);
  		}
  		
  		HttpResponse response = (HttpResponse)execute(request, false);
  		if (response == null)
		{
			return null;
		}

        String fileData = EncodingUtil.base64Encode(response.getBodyAsBlob());
        
        String url = String.format('data:{0};content-disposition:attachment;base64,{1}', 
    							   new List<String>
    							   {
    							       dropboxFilesGetRequestPath,
    							       fileData
    							   });
    	
    	return new PageReference(url);
  	}
  	
  	public void dropboxFilesPutRequest()
  	{
  		ffhttp_DropboxFiles dropboxFiles = createDropboxFiles();
  		if (dropboxFiles == null)
  		{
  			return;
  		}
  		
  		ffhttp_DropboxFiles.FilesPutRequest request = dropboxFiles.filesPutRequest(dropboxFilesPutRequestPath, dropboxFilesPutRequestFileBody, 
  																				   dropboxFilesPutRequestContentType);
  		
  		if (!String.isEmpty(dropboxFilesPutRequestLocale))
  		{
  			request.setLocale(dropboxFilesPutRequestLocale);
  		}
  	
  		if (dropboxFilesPutRequestOverwrite != null)
  		{
  			request.setOverwrite(dropboxFilesPutRequestOverwrite);
  		}
  		
  		if (!String.isEmpty(dropboxFilesPutRequestParentRev))
  		{
  			request.setParentRev(dropboxFilesPutRequestParentRev);
  		}
  	
  		if (dropboxFilesPutRequestAutorename != null)
  		{
  			request.setAutoRename(dropboxFilesPutRequestAutorename);
  		}
  	
  		execute(request);   		
  	}
  	 
  	public void dropboxMetadataRequest()
  	{
  		ffhttp_DropboxFiles dropboxFiles = createDropboxFiles();
  		if (dropboxFiles == null)
  		{
  			return;
  		}
  		
  		ffhttp_DropboxFiles.MetaDataRequest request = dropboxFiles.metaDataRequest(dropboxMetadataRequestPath);
  		
  		if (dropboxMetadataRequestFileLimit != null
  		  && dropboxMetadataRequestFileLimit > 0)
  		{
  			request.setFileLimit(dropboxMetadataRequestFileLimit);
  		}
  		
  		if (!String.isEmpty(dropboxMetadataRequestHash))
  		{
  			request.setHash(dropboxMetadataRequestHash);
  		}
  		
  		if (dropboxMetadataRequestList != null)
  		{
  			request.setList(dropboxMetadataRequestList);
  		}
  		
  		if (dropboxMetadataRequestIncludeDeleted != null)
  		{
  			request.setIncludeDeleted(dropboxMetadataRequestIncludeDeleted);
  		}

		if (!String.isEmpty(dropboxMetadataRequestRev))
		{
			request.setRev(dropboxMetadataRequestRev);
		}
		
		if (!String.isEmpty(dropboxMetadataRequestLocale))
		{
			request.setLocale(dropboxMetadataRequestLocale);
		}
		
		if (dropboxMetadataRequestIncludeMediaInfo != null)
		{
			request.setIncludeMediaInfo(dropboxMetadataRequestIncludeMediaInfo);
		}
		
  		execute(request);	
  	}
  	
  	public void dropboxDeltaRequest()
  	{
  		ffhttp_DropboxFiles dropboxFiles = createDropboxFiles();
  		if (dropboxFiles == null)
  		{
  			return;
  		}
  		
  		ffhttp_DropboxFiles.DeltaRequest request = dropboxFiles.deltaRequest();
  		
  		if (!String.isEmpty(dropboxDeltaRequestCursor))
  		{
  			request.setCursor(dropboxDeltaRequestCursor);
  		}
  		
  		if (!String.isEmpty(dropboxDeltaRequestLocale))
  		{
  			request.setLocale(dropboxDeltaRequestLocale);
  		}
  		
  		if (!String.isEmpty(dropboxDeltaRequestPathPrefix))
  		{
  			request.setPathPrefix(dropboxDeltaRequestPathPrefix);
  		}
  		
  		if (dropboxDeltaRequestIncludeMediaInfo != null)
  		{
  			request.setIncludeMediaInfo(dropboxDeltaRequestIncludeMediaInfo);
  		}
  		
  		execute(request);	
  	}
  	
  	public void dropboxDeltaLatestCursorRequest()
  	{
  		ffhttp_DropboxFiles dropboxFiles = createDropboxFiles();
  		if (dropboxFiles == null)
  		{
  			return;
  		}
  		
  		ffhttp_DropboxFiles.DeltaLatestCursorRequest request = dropboxFiles.deltaLatestCursorRequest();
  		
  		if (!String.isEmpty(dropboxDeltaLatestCursorRequestPathPrefix))
  		{
  			request.setPathPrefix(dropboxDeltaLatestCursorRequestPathPrefix);
  		}
  		
  		if (dropboxDeltaLatestCursorRequestIncludeMediaInfo != null)
  		{
  			request.setIncludeMediaInfo(dropboxDeltaLatestCursorRequestIncludeMediaInfo);
  		}
  		
  		execute(request);	
  	}
  	
  	public void dropboxLongpollDeltaRequest()
  	{
  		ffhttp_DropboxFiles dropboxFiles = createDropboxFiles();
  		if (dropboxFiles == null)
  		{
  			return;
  		}
  		
  		ffhttp_DropboxFiles.LongpollDeltaRequest request = dropboxFiles.longpollDeltaRequest();
  		
  		if (!String.isEmpty(dropboxLongpollDeltaRequestCursor))
  		{
  			request.setCursor(dropboxLongpollDeltaRequestCursor);
  		}
  		
  		if (dropboxLongpollDeltaRequestTimeout != null && dropboxLongpollDeltaRequestTimeout > 0)
  		{
  			request.setTimeout(dropboxLongpollDeltaRequestTimeout);
  		}
  		
  		execute(request);
  	}
  	
  	public void dropboxRevisionsRequest()
  	{
  		ffhttp_DropboxFiles dropboxFiles = createDropboxFiles();
  		if (dropboxFiles == null)
  		{
  			return;
  		}
  		
  		ffhttp_DropboxFiles.RevisionsRequest request = dropboxFiles.revisionsRequest(dropboxRevisionsRequestPath);
  		
  		if (dropboxRevisionsRequestRevLimit != null 
  		 && dropboxRevisionsRequestRevLimit > 0)
  		{
  			request.setRevLimit(dropboxRevisionsRequestRevLimit);
  		}
  		
  		if (!String.isEmpty(dropboxRevisionsRequestLocale))
  		{
  			request.setLocale(dropboxRevisionsRequestLocale);
  		}
  		
  		execute(request);
  	}
  	
  	public void dropboxRestoreRequest()
  	{
  		ffhttp_DropboxFiles dropboxFiles = createDropboxFiles();
  		if (dropboxFiles == null)
  		{
  			return;
  		}
  		
  		ffhttp_DropboxFiles.RestoreRequest request = dropboxFiles.restoreRequest(dropboxRestoreRequestPath);
  		
  		if (!String.isEmpty(dropboxRestoreRequestRev))
  		{
  			request.setRev(dropboxRestoreRequestRev);
  		}
  		
  		if (!String.isEmpty(dropboxRestoreRequestLocale))
  		{
  			request.setLocale(dropboxRestoreRequestLocale);
  		}
  		
  		execute(request);
  	}
  	
  	public void dropboxSearchRequest()
  	{
  		ffhttp_DropboxFiles dropboxFiles = createDropboxFiles();
  		if (dropboxFiles == null)
  		{
  			return;
  		}
  		
  		ffhttp_DropboxFiles.SearchRequest request = dropboxFiles.searchRequest(dropboxSearchRequestPath);
  		
  		if (!String.isEmpty(dropboxSearchRequestQuery))
  		{
  			request.setQuery(dropboxSearchRequestQuery);
  		}
  		
  		if (dropboxSearchRequestFileLimit != null 
  		  && dropboxSearchRequestFileLimit > 0)
  		{
  			request.setFileLimit(dropboxSearchRequestFileLimit);
  		}
  		
   		if (dropboxSearchRequestIncludeDeleted != null)
   		{
   			request.setIncludeDeleted(dropboxSearchRequestIncludeDeleted);
   		}
    	
   		if (!String.isEmpty(dropboxSearchRequestLocale))
  		{
  			request.setLocale(dropboxSearchRequestLocale);
  		}
  		
  		execute(request);
  	}
  	
  	public void dropboxSharesRequest()
  	{
  		ffhttp_DropboxFiles dropboxFiles = createDropboxFiles();
  		if (dropboxFiles == null)
  		{
  			return;
  		}
  		
  		ffhttp_DropboxFiles.SharesRequest request = dropboxFiles.sharesRequest(dropboxSharesRequestPath);
  	
  		if (dropboxSharesRequestShortUrl != null)
   		{
   			request.setShortUrl(dropboxSharesRequestShortUrl);
   		}
    	
   		if (!String.isEmpty(dropboxSharesRequestLocale))
  		{
  			request.setLocale(dropboxSharesRequestLocale);
  		}
  		
  		execute(request);
  	}
  	
  	public void dropboxMediaRequest()
  	{
  		ffhttp_DropboxFiles dropboxFiles = createDropboxFiles();
  		if (dropboxFiles == null)
  		{
  			return;
  		}
  		
  		ffhttp_DropboxFiles.MediaRequest request = dropboxFiles.mediaRequest(dropboxMediaRequestPath);
  		
  		if (!String.isEmpty(dropboxMediaRequestLocale))
  		{
  			request.setLocale(dropboxMediaRequestLocale);
  		}
  		
  		execute(request);
  	}
  	
  	public void dropboxCopyRefRequest()
  	{
  		ffhttp_DropboxFiles dropboxFiles = createDropboxFiles();
  		if (dropboxFiles == null)
  		{
  			return;
  		}
  		
  		ffhttp_DropboxFiles.CopyRefRequest request = dropboxFiles.copyRefRequest(dropboxCopyRefRequestPath);
  		execute(request);
  	}
  	
  	public PageReference dropboxThumbnailsRequest()
  	{
  		ffhttp_DropboxFiles dropboxFiles = createDropboxFiles();
  		if (dropboxFiles == null)
  		{
  			return null;
  		}
  		
  		ffhttp_DropboxFiles.ThumbnailsRequest request = dropboxFiles.thumbnailsRequest(dropboxThumbnailsRequestPath);
  		
  		if (!String.isEmpty(dropboxThumbnailsRequestFormat))
		{  		
			request.setFormat(dropboxThumbnailsRequestFormat);
		}
		else
		{
			dropboxThumbnailsRequestFormat = request.getFormat();
		}
		
		if (!String.isEmpty(dropboxThumbnailsRequestSize))
		{
			request.setSize(dropboxThumbnailsRequestSize);
		}
		
		HttpResponse response = (HttpResponse)execute(request, false);
		if (response == null)
		{
			return null;
		}
		
		String fileData = EncodingUtil.base64Encode(response.getBodyAsBlob());
        
        String url = String.format('data:image/*;content-disposition:attachment;base64,{0}', 
    							   new List<String>
    							   {
    							       fileData
    							   });
    	
    	return new PageReference(url);
  	}
  	
  	public PageReference dropboxPreviewsRequest()
  	{
  		ffhttp_DropboxFiles dropboxFiles = createDropboxFiles();
  		if (dropboxFiles == null)
  		{
  			return null;
  		}
  		
  		ffhttp_DropboxFiles.PreviewsRequest request = dropboxFiles.previewsRequest(dropboxPreviewsRequestPath);
  		
  		if (!String.isEmpty(dropboxPreviewsRequestRev))
  		{
  			request.setRev(dropboxPreviewsRequestRev);
  		}
  		
  		HttpResponse response = (HttpResponse)execute(request, false);
  		if (response == null)
		{
			return null;
		}
	
        String fileData = EncodingUtil.base64Encode(response.getBodyAsBlob());
        
        String url = String.format('data:{0};content-disposition:attachment;base64,{1}', 
    							   new List<String>
    							   {
    							       dropboxFilesGetRequestPath,
    							       fileData
    							   });
    	
    	return new PageReference(url);
  	}
  	
  	public void dropboxChunkedUploadRequest()
  	{
  		ffhttp_DropboxFiles dropboxFiles = createDropboxFiles();
  		if (dropboxFiles == null)
  		{
  			return;
  		}
  		
  		if (dropboxChunkedUploadRequestFileBody == null)
  		{
  			error('You must select a file.');
  			return;
  		}
  		
  		String uploadId = null;
		
		String fileBodyEncodedStr = EncodingUtil.base64Encode(dropboxChunkedUploadRequestFileBody);
		Integer fileBodyEncodedStrLength = fileBodyEncodedStr.length();
		
		Integer dropboxServerOffset = 0;
		
		Integer strOffset = 0;
		while (strOffset < fileBodyEncodedStrLength)
		{
			Integer endOffset = strOffset + CHUNK_SIZE;
			if (endOffset > fileBodyEncodedStrLength)
			{
				endOffset = fileBodyEncodedStrLength;
			}
			
			String chunkStr = fileBodyEncodedStr.subString(strOffset, endOffset);
			Blob blobChunk = EncodingUtil.base64Decode(chunkStr);
			
			ffhttp_DropboxFiles.ChunkedUploadRequest request = dropboxFiles.chunkedUploadRequest(blobChunk, 
																								 dropboxChunkedUploadRequestContentType);
			
			ffhttp_DropboxModelUploadChunk uploadChunk = (ffhttp_DropboxModelUploadChunk)execute(request);
			if (uploadChunk == null)
			{
			 	error('Error with request');
			 	return;
			}
			
			uploadId = uploadChunk.getUploadId();
			dropboxServerOffset = uploadChunk.getOffset();
			
			strOffset += CHUNK_SIZE;
		}
  	}
  	
  	public void dropboxCommitChunkedUploadRequest()
  	{
  		ffhttp_DropboxFiles dropboxFiles = createDropboxFiles();
  		if (dropboxFiles == null)
  		{
  			return;
  		}
  		
  		ffhttp_DropboxFiles.CommitChunkedUploadRequest request = dropboxFiles.commitChunkedUploadRequest(dropboxCommitChunkedUploadRequestPath);
  		
  		if (!String.isEmpty(dropboxCommitChunkedUploadRequestUploadId))
  		{
  			request.setUploadId(dropboxCommitChunkedUploadRequestUploadId);
  		}
  		
  		if (!String.isEmpty(dropboxCommitChunkedUploadRequestLocale))
  		{
  			request.setLocale(dropboxCommitChunkedUploadRequestLocale);
  		}
  	
  		if (dropboxCommitChunkedUploadRequestOverwrite != null)
  		{
  			request.setOverwrite(dropboxCommitChunkedUploadRequestOverwrite);
  		}
  		
  		if (!String.isEmpty(dropboxCommitChunkedUploadRequestParentRev))
  		{
  			request.setParentRev(dropboxCommitChunkedUploadRequestParentRev);
  		}
  	
  		if (dropboxCommitChunkedUploadRequestAutorename != null)
  		{
  			request.setAutoRename(dropboxCommitChunkedUploadRequestAutorename);
  		}
  	
  		execute(request);
  	}
  	
  	private ffhttp_DropboxFiles createDropboxFiles()
  	{
  		ffhttp_Dropbox db = getDropboxClient();
  		if (db == null)
    	{
    		return null;
    	}
    	
     	return db.files();   
  	}
  	 
  	/** 
  	 * File Operation requests
  	 */
  	public void dropboxCopyRequest()
	{
		ffhttp_DropboxFileOperations dropboxFileOperations = createDropboxFileOperations();
		if (dropboxFileOperations == null)
		{
			return;
		}
		
		ffhttp_DropboxFileOperations.CopyRequest request = dropboxFileOperations.copyRequest();
		request.setRoot(dropboxCopyRequestRoot);
		request.setToPath(dropboxCopyRequestToPath);
		request.setLocale(dropboxCopyRequestLocale);
		
		if (String.isEmpty(dropboxCopyRequestFromCopyRef))
		{
			request.setFromPath(dropboxCopyRequestFromPath);
		}
		else
		{
			request.setFromCopyRef(dropboxCopyRequestFromCopyRef);
		}
		
		execute(request);
	}
	
	public void dropboxCreateFolderRequest()
	{
		ffhttp_DropboxFileOperations dropboxFileOperations = createDropboxFileOperations();
		if (dropboxFileOperations == null)
		{
			return;
		}
		
		ffhttp_DropboxFileOperations.CreateFolderRequest request = dropboxFileOperations.createFolderRequest();
		request.setRoot(dropboxCreateFolderRequestRoot);
		request.setPath(dropboxCreateFolderRequestPath);
		request.setLocale(dropboxCreateFolderRequestLocale);
		execute(request);
	}
	
	public void dropboxDeleteRequest()
	{
		ffhttp_DropboxFileOperations dropboxFileOperations = createDropboxFileOperations();
		if (dropboxFileOperations == null)
		{
			return;
		}
		
		ffhttp_DropboxFileOperations.DeleteRequest request = dropboxFileOperations.DeleteRequest();
		request.setRoot(dropboxDeleteRequestRoot);
		request.setPath(dropboxDeleteRequestPath);
		request.setLocale(dropboxDeleteRequestLocale);
		execute(request);
	}
	
	public void dropboxMoveRequest()
	{
		ffhttp_DropboxFileOperations dropboxFileOperations = createDropboxFileOperations();
		if (dropboxFileOperations == null)
		{
			return;
		}
		
		ffhttp_DropboxFileOperations.MoveRequest request = dropboxFileOperations.moveRequest();
		request.setRoot(dropboxMoveRequestRoot);
		request.setToPath(dropboxMoveRequestToPath);
		request.setFromPath(dropboxMoveRequestFromPath);
		request.setLocale(dropboxMoveRequestLocale);
		execute(request);
	}
	
  	private ffhttp_DropboxFileOperations createDropboxFileOperations()
  	{
  		ffhttp_Dropbox db = getDropboxClient();
  		if (db == null)
    	{
    		return null;
    	}
    	
     	return db.fileOperations();   
  	}
  	
  	private ffhttp_Dropbox getDropboxClient()
  	{
  		if (!checkAuthorized())
    	{
    		return null;
    	}
    	
    	String tokenType = connectorService.connector.TokenType__c;
    	String accessToken = connectorService.connector.AccessToken__c;
    	
  		ffhttp_Client.Credentials credentials = new ffhttp_Client.Credentials(tokenType, accessToken);
        return new ffhttp_Dropbox(credentials);
  	}
  	
    /**
     * Helper methods
     */
    private void error(String message) 
    {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, message));
    }
    
    private void info(String message) 
    {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
    }
    
    private Object execute(ffhttp_Client.AbstractClientRequest request) 
    {
    	return execute(request, true);
    }
    private Object execute(ffhttp_Client.AbstractClientRequest request, boolean parse) 
    {
    	Object retval;
    	
        try
        {
            HttpRequest httpRequest = request.buildHttpRequest();
            
            String body = httpRequest.getBody();
            Blob b = httpRequest.getBodyAsBlob();
            if (b != null)
            {
            	body = 'Body consists of blob data';
            }
            
            request.buildHttpRequest();
            
            info('Request: Endpoint: ' + httpRequest.getEndpoint() + ' Body: ' + body);
        
            HttpResponse response = request.executeUnparsed();
            info('Response: Status: ' + response.getStatus() + ' Body: ' + response.getBody());
            
            if (parse)
            {
            	retval = request.parse(response);
            }
            else
            {
            	retval = response;
            }
        }
        catch (Exception ex)
        {
            error('Error whilst processing request: ' + ex.getMessage());
        }  
        
        return retval;  
    }
    
    private Boolean checkAuthorized()
	{
		if (connectorService == null)
		{
			return false;
		}
		
		String validConnector = connectorService.validateConnector();
		if (!String.isEmpty(validConnector))
		{
			error(validConnector);
		}
		
		return String.isEmpty(validConnector);
	}
	
	private Boolean stringValueNotSet(String calloutSection, String name, String value)
	{
		if (String.isEmpty(value))
		{
			error(calloutSection + ': ' + name + ' must be set.');
			return true;
		}
		return false;
	}
	
	private Boolean numberValueNotSet(String calloutSection, String name, Integer value)
	{
		if (value == null || value <= 0)
		{
			error(calloutSection + ': ' + name + ' must be set.');
			return true;
		}
		return false;
	}
}
