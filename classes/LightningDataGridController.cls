public with sharing class LightningDataGridController {
    
	@AuraEnabled
    public static PageResult getsObjectData(String objectname, String fields, String filter, String order,
                                            Decimal pageSize, Decimal pageNumber){
        Integer pSize = (Integer)pageSize;
        Integer offset = ((Integer)pageNumber - 1) * pSize;
        Integer totalRows = 0;
   
        List<Header> hdrs = new List<Header>();
        List<Row> rws = new List<Row>();
        GridData gridData = new GridData();
        
        if(objectname != null && fields != null)
        {    
            try
            { 
                String cntQuery = 'SELECT count() FROM ' + objectname;
				if(filter != '') {
                    cntQuery+= ' WHERE ' + filter;
                }
                totalRows = Database.countQuery(cntQuery); 
                
                String query = 'SELECT ' + fields + ' FROM ' + objectname;
                if(filter != '') {
                    query+= ' WHERE ' + filter;
                }
                if(order != '') {
                    query+= ' ORDER BY ' + order;
                }
                query+= ' LIMIT ' + pageSize + ' OFFSET ' + offset;
                List<sObject> records = Database.query(query);  
                if (!records.isEmpty()) {
                    fields = fields.toLowerCase();  					  //Convert to lowercase
                    fields = fields.replaceAll('\\s+','');				  //remove any spaces
                    List<String> fieldsList = fields.split(',');		  //Split the comma separated string
                    Set<String> fieldsSet = new Set<String>(fieldsList);  //Convert to Map so we can check for matches with contains 
             		list<schema.describeFieldResult> frs = new list<schema.describeFieldResult>();
                    Map<String, Schema.SObjectField> cols = records.getSObjectType().getDescribe().fields.getMap();
                    for(string k : cols.keySet()) {
                        if(fieldsSet.contains(k)) {
                        	//Check to make sure the field is accessible
                           schema.DescribeFieldResult fr = cols.get(k).getDescribe();
                           if(fr.isAccessible()) {	
                           		frs.add(fr); 
                           } else {
                           		//remove from keySet
                           		fieldsSet.remove(k);
                           }
                           	
                        }
                    }
                    for(schema.DescribeFieldResult r: frs) {
                        if(r==null) {
                            continue;
                        } 
                        Header h = new Header();
                        h.title = r.getLabel();
                        h.dataType = String.valueOf(r.getType());
                        hdrs.add(h);
                    }

                    for (sObject obj : records) 
                    {	
                        Row rw = New Row();
                        rw.cols = new List<Col>();
                        for(String columnName : cols.keySet()) 
                        {   
                            if(fieldsSet.contains(columnName)) {
                            	Col c = new Col();
	                            schema.describeFieldResult df = cols.get(columnname).getDescribe();
                                c.value = formatValue(obj.get(columnName), String.valueOf(df.getType()));                              
                                rw.cols.add(c);
                            }     
                        }  
                        rws.add(rw);
                    }
					
                } 
                else
                {
                	throw new AuraHandledException('"No Records Found For Query: ' + query +'"');
                    System.debug('"No Records Found For Query: ' + query +'"');
                }
            }
            catch(Exception ex)
            {
            	 throw new AuraHandledException('"ERROR": "'+ex.getMessage()+'" on line number: ' + ex.getLineNumber());
                 System.debug('"ERROR": "'+ex.getMessage()+'" on line number: ' + ex.getLineNumber());
            }
        }
        
        //Build data for JSON using internal classes
        gridData.rows = rws;
        gridData.headers = hdrs;
        
        //Define the PageResult
        PageResult pr = new PageResult();
        pr.pageSize = pSize;
        pr.page = (Integer) pageNumber;
        pr.total = totalRows;
        pr.jsonData = JSON.serialize(gridData);
        
        return pr;
 
    }
    
    public static String formatValue(Object o, String dataType) {
	    // Apply special formatting for certain data types
	    String value = String.valueOf(o);
	   	if (value!=null) {
		    if (dataType == 'CURRENCY') {
		    	Decimal dec = Double.valueOf(o);
		        value = '$' + dec.format();
		    } 
		    //TODO: Need to add more data formatting scenarios here
	   	}
		return value; 
	}
    
    //Internal Classes used to represent data in the Grid
    public class GridData {
        public List<Header> headers{get;set;}
        public List<Row> rows{get;set;}

    }

    public class Row {
        public List<Col> cols {get;set;}  
    }
    
    public class Col {
        public String value {get;set;}
        public String cssClass {get;set;}
    }
    
    public class Header {
        public String title {get;set;}
        public String isSortable {get;set;}
        public String dataType {get;set;}
        public String cssClass {get;set;}
            
    }
    
    public class PageResult {
        @AuraEnabled
        public Integer pageSize { get;set; }
        
        @AuraEnabled
        public Integer page { get;set; }
        
        @AuraEnabled
        public Integer total { get;set; }
        
        @AuraEnabled
        public String jsonData { get;set; }
    }
        
}