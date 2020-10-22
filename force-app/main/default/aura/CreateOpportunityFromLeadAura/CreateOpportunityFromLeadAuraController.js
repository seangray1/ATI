({
    refreshView: function(component, event) {
        // refresh the view
        $A.get("e.force:refreshView").fire();
        $A.get("e.force:closeQuickAction").fire();
    },
    closeForm: function(component, event, helper) {
        
        $A.get("e.force:closeQuickAction").fire();
            },
    doInit: function(component, event, helper) {
        console.log('Testing if it starts ' );
        var result=decodeURIComponent((new RegExp('[?|&]' + param + '=' + '([^&;]+?)(&|#|;|$)').
        exec(location.search)||[,""])[1].replace(/\+/g, '%20'))||null;
console.log('Param ' + param + ' from URL = ' + result);
        console.log('Result',result);
            },
})