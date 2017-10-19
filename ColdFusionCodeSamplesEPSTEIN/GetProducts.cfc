<!---Name: getproducts.cfc
Developer: Jeff Epstein, 2006
Purpose:  Methods involved with product handling.
--->
<!---This CFC returns a list of products, either with short or detailed records, it has methods for both. -->

<!--- Product  component --->
<cfcomponent hint="Product processing">

   <!--- List products method --->
   <cffunction name="list"
               returntype="query"
               hint="get products list ">

      <!--- Get products --->
      <cfquery name="products" datasource="#dsn#">
      SELECT upcnumberid as productid, title, description_short as blurb
      FROM tblproducts
      order by title
      </cfquery>

      <cfreturn products>
   </cffunction>

   <!--- get specific product method --->
   <cffunction name="get"
               returntype="query"
               hint="Get a complete product record">
      <cfargument name="productid"
                  type="string"
                  required="true"
                  hint="product id is required">

      <!--- Get product detail --->
      <cfquery name="detail" datasource="#dsn#">
     SELECT upcnumberid as productid, title, description_long as description, priceid, price
     FROM tblproducts, tblprice
	 WHERE tblproducts.priceid = tblpriceid
      order by title
      </cfquery>

      <cfreturn user>
   </cffunction>


</cfcomponent>
<!-----dev note:  to use this cfc,  just invoke as follows:

<!--- get product list --->
<cfinvoke component="productsr"
          method="list"
          returnvariable="listret">

The value returned by this <cfinvoke> call is a query.
--->

