({
	getData : function(cmp, page) {
		cmp.set("v.errorMsg", '');
        var action = cmp.get("c.getsObjectData");
        var pageSize = cmp.get("v.pageSize");
        action.setParams({"objectname": cmp.get("v.sobject"), 
                          "fields": cmp.get("v.fields"),
                          "filter": cmp.get("v.filter"),
                          "order": cmp.get("v.order"),
                          "pageSize": pageSize,
            			  "pageNumber": page || 1
                         });
        action.setCallback(this, function(response){
            if (response.getState() === "SUCCESS"){
                var result = response.getReturnValue();
                cmp.set("v.gridData", JSON.parse(result.jsonData));
            	cmp.set("v.page", result.page);
            	cmp.set("v.total", result.total);
            	cmp.set("v.pages", Math.ceil(result.total/pageSize));
            } else {
            	//Handle errors
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                    	cmp.set("v.errorMsg", errors[0].message);
                        cmp.set("v.isError", true);
                    }
                } else {
                	cmp.set("v.errorMsg", "unknown error, response state: " + response.getState());
                    cmp.set("v.isError", true);
                }
            }
        });
        $A.enqueueAction(action);
    }
})