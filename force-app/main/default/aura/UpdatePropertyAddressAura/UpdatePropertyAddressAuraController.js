({
    ButtonClicked: function (cmp, event) {
        var address = cmp.find("myaddress");
        var isValid = address.checkValidity();
        if(isValid) {
            var inputAddress = component.find("myaddress");
            var action = component.get("c.UpdateProperty");
             action.setParams({recordId : component.get("v.recordId"),
             AddressLine1 : inputAddress.get("v.street"),
             City : inputAddress.get("v.city"),
             State : inputAddress.get("v.province"),
             Zip : inputAddress.get("v.postalCode")});
             action.setCallback(this, function(response){
             var state = response.getState(); 
             if (state === "SUCCESS") {
                $A.get("e.force:refreshView").fire();
                $A.get("e.force:closeQuickAction").fire();
                        }
                });
           
        }
        else {
            alert("Enter an Address");
        }
    },
    Cancel: function(component, event) {
        // refresh the view
        $A.get("e.force:refreshView").fire();
        $A.get("e.force:closeQuickAction").fire();
    },
})
