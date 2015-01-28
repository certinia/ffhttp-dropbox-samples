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
 * DropboxAccountController
 *
 * Simple app controller to demonstrate moving an Account attachment to Dropbox.
 */
public with sharing class DropboxAccountController 
{
 	private final Account acct;
    
    public Attachment[] attachments;
    public Note[] notes;
    public ConnectorService connectorService;
    public ffhttp_Dropbox client;
    public Boolean validConnector { get; set; }
   
    /**
     * Constructor
     */
    public DropboxAccountController(ApexPages.StandardController stdController) 
    {
        this.acct = (Account)stdController.getRecord();
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
     * Gets all the attachments related to this Account.
     */
    public Attachment[] getAttachments()
    {
    	if (attachments == null)
    	{
    		attachments = 
    		[
    			SELECT a.Name, a.Body, a.ContentType
    			FROM Attachment a 
    			WHERE a.ParentId =: acct.Id
    		];
    	}
    	return attachments;
    }
 
    /**
     * Gets all the notes related to this Account and checks if the URL is a Dropbox URL.
     */   
    public Note[] getNotes()
    {
    	if (notes == null)
    	{
    		notes = 
    		[
    			SELECT n.Title, n.Body 
    			FROM Note n
    			WHERE n.ParentId =: acct.Id
    		];
    		
    		List<Note> notesToReturn = new List<Note>();
    		for (Note n : notes)
    		{
    			String url = n.Body;
    			if (url.startsWith('https://db.'))
    			{
    				notesToReturn.add(n);
    			}
    		}
    		
    		notes = notesToReturn;
    	}
    	return notes;
    }
    
    /**
     * Main method to transfer the attachment to Dropbox.
     * 
     * This follows the following procedure:
     * 1. Get the attachment that the user selected.
     * 2. Transfer the attached file to Dropbox and then query Dropbox for the URL.
     * 3. Create a new note setting the title to the name of the attached file and the body to the file URL.
     * 4. Delete the attachment.
     */
    public PageReference transferAttachmentToDropbox()
    {
    	String msg = null;
		ApexPages.severity messageCode = ApexPages.severity.ERROR;
		
    	try
    	{
    		String accountId = String.valueOf(acct.Id);
    		
    		//Get the selected attachment.
	    	Integer selectedRow = getSelectedRowAttachment();
	    	
	    	Attachment selectedAttachment = attachments[selectedRow]; 	
	    	String attachmentName = selectedAttachment.Name;
	    	Blob attachmentContent = selectedAttachment.Body;
	    	String attachmentContentType = selectedAttachment.ContentType;
	    	
	    	//Transfer the file to Dropbox.
       		ffhttp_DropboxModelFile df = sendAttachment(attachmentName, attachmentContent, attachmentContentType);
       		String path = df.getPath();
       		
       		//Get the URL for the file
    		ffhttp_DropboxModelUrl url = getUrlForPath(path); 
    		String urlLink = url.getUrl();
    	
    		//Create a new note with the body set to the link.
    		Note dropboxNote = new Note();
    		dropboxNote.title=attachmentName;
    		dropboxNote.body=urlLink;
    		dropboxNote.parentId=accountId;
    		insert dropboxNote;
    		
    		notes.add(dropboxNote);
    		
    		//Delete the attachment as it is no longer required.
			delete selectedAttachment;
			
			//Remove the attachment from the attachment list on this page.
			attachments.remove(selectedRow);
			
			//Show the user a message stating that the upload was successful.
			messageCode = ApexPages.severity.INFO;
			msg = df.getName() + ' was successfully uploaded.';
			
			//Make sure that the connector has the latest token.
			update connectorService.connector;
    	}
    	catch (ffhttp_AppException ex)
    	{
    		msg = 'API Exception calling Dropbox. The file was not uploaded.';
    	}
    	
    	ApexPages.addMessage(new ApexPages.message(messageCode, msg));
    	
    	return null;
    }
    
    /**
     * Gets the selected note and redirects to the appropriate URL.
     */
    public PageReference viewFile()
 	{
 		Integer selectedRow = getSelectedRowNote();
 		
 		Note selectedNote = notes.get(selectedRow);
 		String url = selectedNote.Body;	
 		
 		PageReference retval = new PageReference(url);
 		retval.setRedirect(true);
 		return retval;
 	}
 	
    /**
     * Sends an email with the URL of the Dropbox File to all the contacts associated with the account.
     */
 	public PageReference shareFileToAccountContacts()
	{
		//First find all the account contacts.
		Contact[] accountContacts = 
		[
			SELECT c.Email
			FROM Contact c
			WHERE c.AccountId =: acct.Id
		];
		
		Integer selectedRow = getSelectedRowNote();
		if (selectedRow == null)
		{
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'The file to share was not found.'));
			return null;
		}
	
		Note selectedNote = notes.get(selectedRow);
		String selectedNoteFileName = selectedNote.title;
		String selectedNoteUrl = selectedNote.body;
		
		for (Contact accountContact : accountContacts)
		{
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			String[] toAddresses = new String[] {accountContact.Email};
			mail.setToAddresses(toAddresses);
			mail.setSenderDisplayName('FFHTTP Dropbox');
			mail.setSubject('New Dropbox Document');
			mail.setBccSender(false);
			mail.setUseSignature(false);
			mail.setHtmlBody('The file: ' + selectedNoteFileName + ' has been added to Dropbox for you to view: ' + selectedNoteUrl);
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		}
		
		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, selectedNoteFileName + ' was successfully shared.'));
		
		return null;
	}
	
	/**
	 * Deletes the selected file from Google Drive and then deletes the associated note record.
	 */
	public PageReference deleteFile()
	{
		Integer selectedRow = getSelectedRowNote();
	 		
	 	Note selectedNote = notes.get(selectedRow);	
	 		
		try
		{	
			//Delete the file from dropbox.
			deleteFileForNote(selectedNote);
			
			//Remove the note from the page.
			notes.remove(selectedRow);
			
			//Delete the note.
			delete selectedNote;
			
			info(selectedNote.title + ' was successfully deleted.');
		}
		catch (Exception ex)
		{
			error(selectedNote.title + ' was not deleted: ' + ex.getMessage());
		}
		
		return null;
	}
	
	/**
     * Sends an attachment to Dropbox.
     */
    private ffhttp_DropboxModelFile sendAttachment(String attachmentName, Blob attachmentContent, String attachmentContentType)
    {
    	ffhttp_Dropbox client = getDropboxClient();
	    ffhttp_DropboxFiles files = client.files();
    	ffhttp_DropboxFiles.FilesPutRequest request = files.filesPutRequest(attachmentName, attachmentContent, attachmentContentType);
       	return (ffhttp_DropboxModelFile)request.execute();
    }
    
    /**
     * Gets the url for a particular file path.
     */
    private ffhttp_DropboxModelUrl getUrlForPath(String path)
    {
    	ffhttp_Dropbox client = getDropboxClient();
	    ffhttp_DropboxFiles files = client.files();
    	ffhttp_DropboxFiles.SharesRequest request = files.sharesRequest(path);
    	return (ffhttp_DropboxModelUrl)request.execute();
    }
    
    /**
     * Deletes the file for the selected note.
     */
   	private void deleteFileForNote(Note selectedNote)
   	{
   		ffhttp_Dropbox client = getDropboxClient();
	    ffhttp_DropboxFileOperations fileOperations = client.fileOperations();
	    ffhttp_DropboxFileOperations.DeleteRequest request = fileOperations.deleteRequest();
	    request.setPath(selectedNote.title);
	    request.setRoot('auto');
	    request.execute();
   	}
	
	/**
     * Gets the Dropbox client
     */
    private ffhttp_Dropbox getDropboxClient()
    {
    	if (client == null)
    	{
    		ffhttp_Client.Credentials credentials = new ffhttp_Client.Credentials(connectorService.connector.TokenType__c, 
    																			  connectorService.connector.AccessToken__c);
    		client = new ffhttp_Dropbox(credentials);
    	}
    	return client;
    }
    
	/**
	 * Methods to work out which attachment and row have been selected on the VisualForce page.
	 */
    private virtual Integer getSelectedRowAttachment()
    {
    	return getSelectedRow('attachmentRowNumber');
    }
    private virtual Integer getSelectedRowNote()
    {
    	return getSelectedRow('noteRowNumber');
    }
    private Integer getSelectedRow(String parameter)
 	{
 		PageReference reference = ApexPages.currentPage();
		Map<String, String> referenceParameter = reference.getParameters();
		Object rowIndexObj = referenceParameter.get(parameter);
		return Integer.valueOf(rowIndexObj);
	}
 	
 	void info(String msg)
 	{
 		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, msg));
 	}
 	
 	void error(String msg)
 	{
 		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, msg));
 	}
}
