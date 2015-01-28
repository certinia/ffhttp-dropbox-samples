Dropbox Sample Apps
===================

<a href="https://githubsfdeploy.herokuapp.com?owner=financialforcedev&repo=ffhttp-dropbox-samples">
    <img alt="Deploy to Salesforce"
        src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/src/main/webapp/resources/img/deploy.png">
</a>

Summary
-------
This app (or collection of apps) has been built to demonstrate the use of the [Dropbox](https://github.com/financialforcedev/ffhttp-dropbox) and [Core](https://github.com/financialforcedev/ffhttp-core) libraries. 

It consists of two components:
1. A test harness that provides a UI for performing all of the Dropbox API calls.
2. An implementation of the library that allows Account attachments to be transferred to Dropbox. 

**Note:** Currently, no test coverage for the sample apps has been provided.

Key Features
------------
+ Demonstrates each of the API calls found at https://www.dropbox.com/developers/core/docs.
+ Demonstrates the use of the [/files_put](https://www.dropbox.com/developers/core/docs#files_put) API call by transferring an Account attachment to Dropbox.
+ Demonstrates the use of the [/shares](https://www.dropbox.com/developers/core/docs#shares) API call by sharing the transferred file to all the Account contacts.
+ Demonstrates the use of the [/fileops/delete](https://www.dropbox.com/developers/core/docs#fileops-delete) API call by deleting the file from Dropbox.

Configuration
-------------

This section explains how to configure the Dropbox Sample Apps.

1. Deploy the [Core](https://githubsfdeploy.herokuapp.com?owner=financialforcedev&repo=ffhttp-core) package to your Salesforce organisation.
2. Deploy the [OAuth Sample App](https://githubsfdeploy.herokuapp.com?owner=financialforcedev&repo=ffhttp-core-samples).
3. Deploy the [Dropbox](https://githubsfdeploy.herokuapp.com/?owner=financialforcedev&repo=ffhttp-dropbox) package.
4. Deploy the [Dropbox Sample App](https://githubsfdeploy.herokuapp.com/?owner=financialforcedev&repo=ffhttp-dropbox-samples).
5. Go to **Setup** > **Manage Users** > **Users**.
6. Select your user.
7. Select **Edit Assignments** in the **Permission Set Assignments** section.
8. Add the **OAuth Sample App Permissions** and **Dropbox Sample App Permissions** permission sets and **Save**.
9. Select the **Dropbox Sample App** from the app menu. 
    + The **Test Harness**, **Account**, **Connector Types** and **Connectors** tabs should be displayed.
10. Create a Dropbox App following the steps in the **Create an app in Dropbox** section below.
11. Follow the steps in the **Create a Dropbox Connector** section below.
12. Go to **Setup** > **Customize** > **Accounts** > **Page Layouts**.
13. Select **Edit** on the **Account Layout**.
14. Select the **Buttons** section.
15. Add the **Move Attachments to Dropbox** button to the **Custom Buttons** section.
16. Save the layout.
17. Select an account from the **Accounts** tab.
    + The **Move Attachments to Dropbox** button should be displayed.

###Create an app in Dropbox

1. Log in to your Dropbox account.
2. Go to https://www.dropbox.com/developers/apps and select **Create App**.
3. Select **Dropbox API app** for **What type of data does your app need to store on Dropbox?**.
4. Select **Files and datastores** for **Can your app be limited to its own folder?**.
5. Select **No** as **Can your app be limited to its own folder?**.
6. Select **All file types** for **What type of files does your app need access to?**.
7. Enter an **App name** and select **Create App**.
8. Set the **Redirect URIs** to the URL of the Salesforce organisation e.g. https://eu3.salesforce.com/apex/conector.
9. Make sure you know the **App Key** and **App Secret** as they will be needed later.

###Create a Dropbox Connector 
1. Log in to your Salesforce organisation.
2. Go to the **Developer Console** and select **Debug** > **Open Execute Anonymous Window**.
3. Run the following code changing the parameters to the appropriate values:

    ```
    DropboxConfigure.configure(<App Key>, <App Secret>, <Salesforce domain>);
    ```

4. Check that the connector has been created and activate it.

Use
---

Once the project is configured:

###Test Harness
1. Select the **Test Harness** tab.
2. Check that you get a message starting with 'Successful authentication'. If you do not, check that all the configuration steps have been peformed correctly.
3. Expand any section to display the API calls, then select **Submit** to test the call.

###Account Transfer Sample App
1. Select the **Accounts** tab and view an account.
2. In the **Notes & Attachments** section select **Attach File**. Choose a file and attach it.
3. Select the **Move Attachments to Dropbox** button.
4. Choose an attachment and select **Transfer**.
5. The attachment will have been transferred to Dropbox.

Reporting Issues & Enhancements
-------------------------------

Please report any issues using the github [issues](https://github.com/financialforcedev/ffhttp-dropbox-samples/issues) feature. Suggestions / bug reports are welcome as are extensions containing additional functionality.
