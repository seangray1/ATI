({    
    doInit: function(component,event,helper){
        var DriveLink = component.get("v.GDriveLink");
        var SharingGLinkFileName = component.get("v.SharingGLinkFileName");
        var htmlConte = 'Hi,\n\n I have shared the following document with you:<a href="'+DriveLink+'">"'+SharingGLinkFileName+'"</a> \n\n Thanks, \n ATI Support';
        component.set('v.emailContent', htmlConte);
        var Subject = 'ATI shared a file with you';
        component.set('v.emailSubject', Subject);
    },
    
    closeModel: function (component,event,helper){
        component.set('v.ShareOptions', false);
    },
    
    CoptyToClipBoard: function(component,event,helper){
        var CopyDate = component.get("v.GDriveLink");
        if(CopyDate!=''){
            var hiddenInputEle = document.createElement("input");
            hiddenInputEle.setAttribute("value", CopyDate);
            document.body.appendChild(hiddenInputEle);
            hiddenInputEle.select();
            document.execCommand("copy");
            document.body.removeChild(hiddenInputEle);
            var toastEvent = $A.get("e.force:showToast");
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
        /*var allValid = component.find('emailForm').reduce(function (validSoFar, inputCmp) {
         inputCmp.showHelpMessageIfInvalid();
         return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        alert(allValid);*/
        /* var ToEmail = component.find('emailForm').get('v.value');
        var Subject = component.find('EmailSubject').get('v.value');
        var Content = component.find('EmailContent').get('v.value');
        if (ToEmail!='' && Subject!='' && Content!='') {
            //ToEmail = split(ToEmail,';');
            console.log('ToEmail: '+ToEmail);
        } else {
            //display error
            component.set("v.error", 'Please update the invalid form entries and try again.');
        }*/
        /*  var commentForm = component.find('EmailForm'), valid;
		commentForm.showHelpMessageIfInvalid();
		valid = commentForm.get("v.validity").valid;
        alert(valid);
        alert(component.find('EmailForm').get('v.value'));
        
        */
        var action = component.get("c.sendEmail");
        action.setParams({
            "toAddresses":component.find('EmailForm').get('v.value'),
            "Subject": component.find('EmailSubject').get('v.value'),
            "htmlBody": component.find('EmailContent').get('v.value')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state == 'SUCCESS') {
                var result = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success!",
                    "message": "The file had been shared successfully."
                });
                toastEvent.fire();
                component.set('v.ShareOptions', false);
            }
            else if (response.getState() === "ERROR") {
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"error",
                    "title": "Error!",
                    "message": errors[0].message
                });
                //toastEvent.fire();
            }
        })  
        $A.enqueueAction(action);
    }
    
})