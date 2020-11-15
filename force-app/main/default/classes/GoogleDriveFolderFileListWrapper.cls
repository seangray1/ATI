/*******************************************************************************************
* @author           Kevin
* @version          1.0 
* @date             12-AUG-2020
* @Status           In-Progress
* @Class Name       GoogleDriveFolderFileListWrapper
* @description      	
*********************************************************************************************
Version     Date      Team          Comments
*********************************************************************************************
* 1      	Aug 2020    Kevin        Initial Creation(JIRA AR-653)
*********************************************************************************************/
public class GoogleDriveFolderFileListWrapper {
    public class LastModifyingUser {
        public String displayName;
        public String emailAddress;
        public String kind;
        public Boolean me;
        public String permissionId;
    }
    public List<Result> result;
    public String parentId;
    public String webViewLink;
    
    public class Owners {
        public String displayName;
        public String emailAddress;
        public String kind;
        public Boolean me;
        public String permissionId;
    }
    
    public class Result {
        public String iconLink;
        public String filePath;
        public String id;
        public LastModifyingUser lastModifyingUser;
        public String mimeType;
        public Datetime modifiedTime;
        public String name;
        public List<Owners> owners;
        public List<String> parents;
        public String webViewLink;
        public String fileExtension;
        public String size;
        public String webContentLink;
        public String description;
    }
    public static GoogleDriveFolderFileListWrapper parse(String json) {
        return (GoogleDriveFolderFileListWrapper) System.JSON.deserialize(json, GoogleDriveFolderFileListWrapper.class);
    }
}