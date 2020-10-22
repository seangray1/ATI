/*******************************************************************************************
* @author           Suman
* @version          1.0 
* @date             24-AUG-2020
* @Status           In-Progress
* @Class Name       GoogleDriveNewFolderFileDetailsWrapper
* @description      	
*********************************************************************************************
Version     Date      Team          Comments
*********************************************************************************************
* 1      	Aug 2020    Suman        Initial Creation(JIRA AR-653)
*********************************************************************************************/
public class GoogleDriveNewFolderFileDetailsWrapper {
    
    public static GoogleDriveNewFolderFileDetailsWrapper parse(String json) {
        return (GoogleDriveNewFolderFileDetailsWrapper) System.JSON.deserialize(json, GoogleDriveNewFolderFileDetailsWrapper.class);
    }
    
    public class ModifiedTime {
        public Boolean dateOnly;
        public Integer timeZoneShift;
        public Long value;
    }
    
    public class LastModifyingUser {
        public String displayName;
        public String emailAddress;
        public String kind;
        public Boolean me;
        public String permissionId;
    }
    public Result result;
    
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
        public ModifiedTime modifiedTime;
        //public Datetime modifiedTime;
        public String name;
        public List<Owners> owners;
        public String webViewLink;
        public String fileExtension;
        //public Integer size;
        public String size;
        public String webContentLink;
        public String description;
    }
    
}