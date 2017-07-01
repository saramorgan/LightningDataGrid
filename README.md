# Lightning Data Grid

Generic Component used to display any sObject data in a read-only Lightning Grid. It utilizes the following attributes to make the component configureable:

Attribute Name  |  Description                                                                                      | Default
--------------  |  ----------------------------------------------------------------------------------------------   | -------
sobject			|   Name of sObject to query                                                                        |   Account
fields          |   Comma separated list of fields to retrieve in SOQL query                                        |   Name, AccountNumber, AnnualRevenue
filter          |   Used to filter records in SOQL query (DO NOT INCLUDE WHERE CLAUSE ie, "LastName Like 'B%'")     |   No Default Specified
order			|   Used to Order the query results (DO NOT INCLUDE ORDER BY CLAUSE)								|	Name
pagesize        |   Number of records to limit per page                                                             |   5

## Usage

To use the LightningDataGrid component, you must host it within a stand-alone app component or access it from Lightning App Builder.

### Implementing from a stand-alone Lightning App
A default Lightning app (LightningDataGridApp.app) has been included in this repository which implements a default version of the component. This means that no configureable attributes are used to customize the component.

If you want to render a customized version of the component, you will need to set attributes such as in the following example, which renders a list of Contacts with a last name starting with B:

```
<aura:application extends="force:slds">

        <c:LightningDataGrid sobject="Contact" fields="Name, Phone, Email" filter="LastName like 'B%'" />
    
</aura:application>
```

### Implementing from the Lightning App Builder

You can use the Lightning App Builder to add this component to either a App Page, Home Page, or Record Page.

For example, this is a screenshot of using the Lightning App Builder to include the LightningDataGrid component in a single column App Page:

![Lightning App Builder Default Usage] (/images/LightningAppBuilderDefault.png)
 
## Special Features

1. **IsAccessibility Checks** - If a field is included that is not accessible to the logged in user, that column will not be displayed in the resulting grid
2. **Pagination** - Includes special Paginator component used to limit the number of record displayed per page and allow the user to page through all the results

For example, this is a screenshot of what the component looks like using the new Paginator component

![Lightning Component With Pagination] (/images/LightningAppBuilderWithPagination.png)

