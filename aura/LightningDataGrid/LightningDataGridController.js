
({
	doInit : function(component, event, helper) {
        helper.getData(component);
    },
    onPagePrevious: function(component, event, helper) {
		var page = component.get("v.page") || 1;
        page = page - 1;
        helper.getData(component, page);
	},
	onPageNext: function(component, event, helper) {
		var page = component.get("v.page") || 1;
        page = page + 1;
        helper.getData(component, page);
	}
})