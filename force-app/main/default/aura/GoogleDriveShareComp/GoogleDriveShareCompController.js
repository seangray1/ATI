({
    doInit: function(component,event,helper){
        let DriveLink = component.get("v.GDriveLink");
        let SharingGLinkFileName = component.get("v.SharingGLinkFileName");
        let htmlConte = 'Hi,\n\n I have shared the following document with you:<a href="'+DriveLink+'">"'+SharingGLinkFileName+'"</a> \n\n Thanks, \n ATI Support';
        component.set('v.emailContent', htmlConte);
        let Subject = 'ATI shared a file with you';
        component.set('v.emailSubject', Subject);
    },
    closeModel: function (component,event,helper){
        component.set('v.ShareOptions', false);
    },
    CoptyToClipBoard: function(component,event,helper){
        let CopyDate = component.get("v.GDriveLink");
        if(CopyDate!== ''){
            let hiddenInputEle = document.createElement("input");
            hiddenInputEle.setAttribute("value", CopyDate);
            document.body.appendChild(hiddenInputEle);
            hiddenInputEle.select();
            document.execCommand("copy");
            document.body.removeChild(hiddenInputEle);
            let toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                mode: 'dismissible',
                title: 'Success!',
                message: 'Link has been copied to clipboard.',
                type: 'success',
                duration: '600'
            });
            toastEvent.fire();
        }
    },
    SendEmail: function(component,event,helper){
        let action = component.get("c.sendEmail");
        action.setParams({
            "toAddresses":component.find('EmailForm').get('v.value'),
            "Subject": component.find('EmailSubject').get('v.value'),
            "htmlBody": component.find('EmailContent').get('v.value')
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if(state === 'SUCCESS') {
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success!",
                    "message": "The file had been shared successfully."
                });
                toastEvent.fire();
                component.set('v.ShareOptions', false);
            }
            else if (response.getState() === "ERROR") {
                let errors = response.getError();
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"error",
                    "title": "Error!",
                    "message": errors[0].message
                });
            }
        })
        $A.enqueueAction(action);
    }
})