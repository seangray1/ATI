({
    searchKeyChange: function(component, event) {
        console.log(component.get('v.currentFolderGDId'));
        console.log(component.get('v.parentRecFolderGDId'));
        component.set('v.spinner',true);
        var searchKey = component.find("searchKey").get("v.value");
        var Location = component.find("Locationmenu").get('v.value');
        var googleDriveFolderRef;
        var TimeStartDateParam = null;
        var TimeEndDateParam = null;
        if(searchKey == ''){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"error",
                "title": "Error!",
                "message": 'Enter a valid key search text'
            });
            toastEvent.fire();   
            component.set('v.spinner',false);
        }
        else{
            if(Location == 'Any Location'){
                googleDriveFolderRef = component.get('v.parentRecFolderGDId');
            }
            else{
                googleDriveFolderRef = component.get('v.currentFolderGDId');
            }
            
            var mimeType = component.find("Filemenu").get('v.value');
            var ModifiedType = component.find("Timemenu").get('v.value');
            
            var TimeStartDate = component.get('v.TimeStartDate');
            var TimeEndDate = component.get('v.TimeEndDate');
            
            if(TimeStartDate != ''){
                TimeStartDateParam = TimeStartDate;
            }else{
                TimeStartDateParam = null;
            }
            if(TimeEndDate != ''){
                TimeEndDateParam = TimeEndDate;
            }else{
                TimeEndDateParam = null;
            }
            
            //alert(searchKey+Location+googleDriveFolderRef+mimeType+ModifiedType+TimeStartDateParam+TimeEndDateParam);
            var action = component.get("c.getSearchResultList");
            action.setParams({
                "searchKey": searchKey,
                "googleDriveFolderRef": googleDriveFolderRef,
                "mimeType": mimeType,
                "ModifiedDateFilterType": ModifiedType,
                "StartDate": TimeStartDateParam,
                "EndDate": TimeEndDateParam
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state == 'SUCCESS') {
                    var folderFileList = response.getReturnValue();
                    console.log(folderFileList);
                    component.set('v.folderFilesList', folderFileList);
                    component.set('v.spinner',false);
                }
                else if (response.getState() === "ERROR") {
                    var errorMessage='';
                    var errors = response.getError();
                    if(errors[0].message.includes("uiMessage")){
                        let errorData = JSON.parse(errors[0].message);
                        errorMessage = errorData.uiMessage;
                        this.addErrorLogInAPILogObject(component, errorData);
                    }
                    else {
                        errorMessage = errors[0].message;
                    }
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"error",
                        "title": "Error!",
                        "message": errorMessage
                    });
                    toastEvent.fire();
                    component.set("v.spinner", false);
                    this.reloadCurrentFolderContents(component);
                }
            });
            $A.enqueueAction(action);
        }
    },
    reloadCurrentFolderContents : function(component) {
        var reloadCurrentFolderContentsEvent = component.getEvent("ReloadCurrentFolderContents");
        reloadCurrentFolderContentsEvent.fire();
    },
    addErrorLogInAPILogObject : function(component, apiLogData) {
        var action = component.get('c.addAPILogInDB');
        action.setParams({
            "apiLogData" : JSON.stringify(apiLogData) 
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                var result = response.getReturnValue();
                console.log('API log added.');
            }
            else if (response.getState() === "ERROR") {
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"error",
                    "title": "Error!",
                    "message": errors[0].message
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    ShowMainComponent: function (component, event, helper){
        var reloadCurrentFolderContentsEvent = component.getEvent("RefreshCurrentFolderContent");
        reloadCurrentFolderContentsEvent.fire();
        component.set('v.showSearchComp', false);
    },
    
    handleFileMenu: function (component, event, helper){
        var Label = event.detail.menuItem.get("v.label");
        var selectedMenuItemValue = event.getParam("value");
        //alert(Label);
        var menuItems = component.find("FilemenuItems");
        menuItems.forEach(function (menuItem) {
            if (menuItem.get("v.checked")) {
                menuItem.set("v.checked", false);
            }
            if (menuItem.get("v.value") === selectedMenuItemValue) {
                menuItem.set("v.checked", true);
            }
        });
        component.find('Filemenu').set('v.label', Label);
        component.find('Filemenu').set('v.value', selectedMenuItemValue);
    },
    
    handleLocMenu: function (component,event,helper){
        var Label = event.detail.menuItem.get("v.label");
        var selectedMenuItemValue = event.getParam("value");
        //alert(selectedMenuItemValue);
        var menuItems = component.find("LocmenuItems");
        menuItems.forEach(function (menuItem) {
            if (menuItem.get("v.checked")) {
                menuItem.set("v.checked", false);
            }
            if (menuItem.get("v.value") === selectedMenuItemValue) {
                menuItem.set("v.checked", true);
            }
        });
        component.find('Locationmenu').set('v.label', Label);
        component.find('Locationmenu').set('v.value', selectedMenuItemValue);
    },
    
    handleTimeMenu: function (component,event,helper){
        var Label = event.detail.menuItem.get("v.label");
        var selectedMenuItemValue = event.getParam("value");
        var menuItems = component.find("TimemenuItems");
        
        component.set('v.TimeStartDate','');
        component.set('v.TimeEndDate','');
        
        menuItems.forEach(function (menuItem) {
            if (menuItem.get("v.checked")) {
                menuItem.set("v.checked", false);
            }
            if (menuItem.get("v.value") === selectedMenuItemValue) {
                menuItem.set("v.checked", true);
            }
        });
        component.find('Timemenu').set('v.label', Label);
        component.find('Timemenu').set('v.value', selectedMenuItemValue);
        if(selectedMenuItemValue=='Custom'){
            component.set('v.CustomDatePickPopup', true);
        }
    },
    
    closeModel: function (component,event,helper){
        component.set('v.CustomDatePickPopup', false);
        
        component.find('Timemenu').set('v.value', 'ANY');
        var menuItems = component.find("TimemenuItems");
        menuItems.forEach(function (menuItem) {
            if (menuItem.get("v.checked")) {
                menuItem.set("v.checked", false);
            }
            if (menuItem.get("v.value") === 'ANY') {
                menuItem.set("v.checked", true);
                var LblName = menuItem.get('v.label');
                component.find('Timemenu').set('v.label', LblName);
            }
        });
    },
    
    SubmitCustomDates: function (component,event,helper){
        var StartDate = component.find('CustomInputStartDate').get('v.value');
        var EndDate = component.find('CustomInputEndDate').get('v.value');
        console.log('sd: '+StartDate);
        if(StartDate===''){
            component.find('OppMessage').setError('Enter a valid Start Date.');
        } else if(EndDate===''){
            component.find('OppMessage').setError('Enter a valid End Date.');
        } else if(StartDate>EndDate){
            component.find('OppMessage').setError('Start Date should be less than End Date.');
        } else{
            component.find('OppMessage').setError('');
            component.set('v.TimeStartDate',StartDate);
            component.set('v.TimeEndDate',EndDate);
            var CustomLbl = 'Custom ('+StartDate+'-'+EndDate+')';
            component.find('Timemenu').set('v.label', CustomLbl);
            component.set('v.CustomDatePickPopup', false);
        }
    }
    
})