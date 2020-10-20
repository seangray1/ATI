({
	init : function(cmp, event, helper) {
     console.log('TEsting');
     
    //  var pageReference = {
    //     type: 'standard__component',
    //     attributes: {
    //         componentName: 'c__helloTarget',
    //     },
    //     state: {
    //         "c__firstname": "John"
    //     }
    // };
        // var navService = cmp.find("navService");
        // // Sets the route to /lightning/o/Account/home
        // var pageReference = {
        //     type: 'standard__component',
        //     attributes: {
        //         componentName: 'c:budgetLWC'
        //     },
        //     state : {
        //         c__recordId : cmp.get('v.recordId')
        //     }
        // };
    
        // // Set the URL on the link or use the default if there's an error
        // var defaultUrl = "#";
        // navService.generateUrl(pageReference).then($A.getCallback(function(url) {
        //     window.open(url,'_self'); // This will open in new tab with pageReference with state/URL params you sent while creating instance of pageReference
        // }));
        var pageRef = cmp.get("v.pageReference");
        console.log('Page Ref: '+pageRef);
        var state = pageRef.state; // state holds any query params
        var base64Context = state.inContextOfRef;
        console.log('base'+base64Context);
        if(base64Context){
            if (base64Context.startsWith("1\.")) {
                base64Context = base64Context.substring(2);
            }
            var addressableContext = JSON.parse(window.atob(base64Context));
            var jId = addressableContext.attributes.recordId;
            console.log('PD: '+jId);
            cmp.set("v.jobId", jId);
        }
        
	}
    
})