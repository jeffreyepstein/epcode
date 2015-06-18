//JEFFREY H. EPSTEIN - EXCEPTS OF WRITTEN SENCHA EXTJS4 CODE FOR DATA DISPLAY MODULES:

//BELOW IS A GRID TO DISPLAY DATABASE INFO
{
xtype: 'panel',
id: 'tabTransAct',
layout: {
    type: 'border'
},
title: 'TransAct',
listeners:{
    activate:function(){                                           
        TransActClick();
    }
},
items: [
    {
        xtype: 'gridpanel',
id: 'grdTransAct',
title: '',
store: 'storeTransAct',
/*verticalScrollerType: 'paginggridscroller',
invalidateScrollerOnRefresh: false,
disableSelection: false,*/
region: 'center',
split: true,
viewConfig: {
    emptyText: 'No information to display',
    deferEmptyText: false
},
columns: [
    {
        xtype: 'gridcolumn',
        hidden: true,
        id: 'TransActID',
        dataIndex: 'SYSTEMID',
        text: 'ID'
    },
    {
        xtype: 'gridcolumn',
        hidden: true,
        dataIndex: 'COMPANYID',
        text: 'Company ID'
    },
    {
        xtype: 'gridcolumn',
        dataIndex: 'ACCOUNTNAME',
        text: 'Account'
    },
    {
        xtype: 'datecolumn',
        dataIndex: 'DATELASTRUN',
        text: 'Date Last Run',
        format: 'F d, Y'
    },
    {
        xtype: 'numbercolumn',
        dataIndex: 'OVERALL',
        text: 'Overall',
        format: '0,000.0'
    },
    {
        xtype: 'numbercolumn',
        dataIndex: 'QDF',
        text: 'QDF',
        format: '0,000.0'
    },
    {
        xtype: 'numbercolumn',
        dataIndex: 'GRAPHICS',
        text: 'Graphics',
        format: '0,000.0'
    },
    {
        xtype: 'numbercolumn',
        dataIndex: 'ZI',
        text: 'ZI',
        format: '0,000.0'
    },
    {
        xtype: 'numbercolumn',
        dataIndex: 'Boffo',
        text: 'Boffo',
        format: '0,000.0'
    }
],


....................................................................................................................

//DISPLAY CODE FOR A CUSTOM COLUMN CHART DRIVEN BY A GRID.

{
xtype: 'panel',
id: 'panelOpInfo',
flex: 0.8,
region: 'center',
layout: 'card',
deferredRender: false,
activeItem: 'chartOpInfo',
items: [
    {   
        xtype: 'chart',
    id: 'chartOpInfo',
    store: 'storeOperationInfo',  //see store for config
    //autoSize: true,
    animate: true,
    background: {
        fill: '#fff'
    },
    layout: 'fit',
    insetPadding: 0,
    groupGutter: 0,
    //gutter: 10,
    calculateCategoryCount: true,
    listeners:{
        activate:function(){
            showMainMask(this,'afterrender');
        }
    },
    loadMask: true,   
    axes: [
        {
            type: 'Category',
            fields: ['OperationLABEL'],
            position: 'bottom',
            title: '',                                                   

       
            label: {
                style: {
                    padding: 30,
                    font: '10px Segoe UI'
                },
                rotate: {
                    degrees: 270
                }
            }
        },
        {
            type: 'Numeric',
            fields: ['TRANSACTION-HOURS'],
            position: 'left',
            title: '',
            grid: true,
            label: {
                style: {
                    font: '10px Segoe UI'
                }
            }
        }
       
    ],
    series: [
        {
            type: 'column',
            highlight: true,
            xField: ['OperationLABEL'],
            yField: ['TRANSACTION-HOURS'],
            renderer: function(sprite, storeItem, barAttr, i, store) {
                var stype =    storeItem.data['OperationENDTYPE'];
                if(stype === 0){
                    barAttr.fill = '#93A9CF';
                } else if (stype === 1 | stype === 2 | stype === 4){
                    barAttr.fill = '#DB843D';
                } else if (stype === 3){
                    barAttr.fill = '#AA4643';
                }
                    return barAttr;
            },
// ON CLICKING AN ACCOUNT IN THE CHART, A DETAIL PANEL OPENS WITH ADDITIONAL OPERATION DETAILS ABOUT THE SELECTED ACCOUNT
       
            listeners:{
                itemmousedown : function(obj) {
                    var sid = obj.storeItem.data['OperationID'];
                    var OperationStart = obj.storeItem.data['OperationSTART'];
                    var OperationEnd = obj.storeItem.data['OperationEND'];
                    var runtime = obj.storeItem.data['TRANSACTION-HOURS'];
                    var runtimetext = obj.storeItem.data['RUNTIMETEXT']
                    var endtype = obj.storeItem.data['OperationENDTYPE'];
                    var stype = obj.storeItem.data['OperationENDTYPE'];
                    var acct = obj.storeItem.data['ACCOUNTNAME'];
                    var os = obj.storeItem.data['OS'];
                    var swver = obj.storeItem.data['AB_VEROpInfoON'];
                    var spack = obj.storeItem.data['AB_SERVICEPACK'];
                    var spackval = spack.charAt(spack.length-1);
               
                    if (endtype === 0){
                        var image = 'class="clsDetailsType">Operation terminated normally.'
                    } else if (endtype === 1 | endtype === 2 | endtype === 4){
                            var image = 'Operation killed by user. '
                    } else if (endtype === 3) {
                        var image = 'class="clsDetailsType">Operation terminated unexpectedly.'
                    }
               
                 
                     // update panel body on bar click
                    strTabOperationInfo = Ext.getCmp('tabOperationInfo');
                    strDetailPanelOpInfo = Ext.getCmp('detailPanelOpInfo');
                    strPanelOpInfo = Ext.getCmp('panelOpInfo');
                    strDetailPanelOpInfo.setAutoScroll('true');
                    strDetailPanelOpInfo.body.update(newContent);
                    strPanelOpInfo.flex = 0.5;
                    strDetailPanelOpInfo.flex = 0.4;
                    strTabOperationInfo.doLayout();

                },// end itemmousedown
            } // end listener
        } // end series
]
},//end chartOpInfo

...............................................................................

//BELOW IS A CLICK FUNCTION TO HANDLE A SELECTION IN THE GRID AND OPEN THE ASSOCIATED PANEL BELOW. THE PANEL MAY BE IN AN INDIVIDUAL VIEW, AN OVERALL VIEW, OR IF THE GRID COLUMN SAYS 'NO INFORMATION' A SIMILAR MESSAGE APPEARS IN THE PANEL.



OperationInfoClick = function() {           
            tab = Ext.getCmp('tabOperationInfo');           
            Ext.getCmp('tbpnlDetails').setActiveTab(tab);
            if(!tab.selectedId||tab.selectedId!=iClickedSystem){           
                showMainMask(tab,'afterrender');
                strPanelOpInfo = Ext.getCmp('panelOpInfo');
                accountName = strAccountName;
                strDetailPanelOpInfo = Ext.getCmp('detailPanelOpInfo');
                strNavBar = Ext.getCmp('navBar');
                strNavBtn1 = Ext.getCmp('navBtn1'); // (Ind)
                strNavBtn2 = Ext.getCmp('navBtn2'); // (Overall)
                whereAmI = strPanelOpInfo.layout.activeItem.id;
                if(i_Operation1 > 0){
                       
                // new item click -- OpInfo col display IS NOT 'No Information'   
                    storeOperationInfo = Ext.data.StoreManager.lookup('storeOperationInfo'); //get store
                    storeOperationInfoproxy.extraParams.systemId=iClickedSystem; //re-run store with extra param
                    storeOperationInfo.load();           
               
                    //if ( whereAmI === 'overallPanel' || whereAmI === 'noInfo' ){
                        if ( whereAmI === 'noInfo' ){
                        //we are in overall or noInfo view and need to force-switch to the individual view
                        strPanelOpInfo.layout.setActiveItem('chartOpInfo');
                        strPanelOpInfoflex = 0.8;
                        strDetailPanelOpInfo.flex = 0.1;
                        strDetailPanelOpInfo.show();
                        strNavBtn2.enable();
                        strNavBtn1.setDisabled('true');
                        tab.doLayout();
                    }
                        //  if the layout is showing a compressed chart it means we need to reset the lower

panel.                                   
                    if (strPanelOpInfo.flex < 08) {
                        strPanelOpInfo.flex = 0.8;
                        strDetailPanelOpInfo.flex = 0.1;
   
                    }
                   
                    //detailPanelOpInfo.setAutoScroll('true');
                    strDpsiText = '
This panel will display details of the column clicked within the chart

above.',
                    strDetailPanelOpInfo.body.update(strDpsiText);
                    Ext.getCmp('chartOpInfo').redraw(); //refresh the chart with the new store
                    strNorthText = Ext.getCmp('northText');  //update the title
                    strNorthText.update({html: "     Individual

Operations for "+accountName+""});
                    tab.doLayout();
                   
                } else if (i_Operation1 == 0){
                        // new machine click -- OpInfo col display IS 'No Information'   
                        strPanelOpInfo = Ext.getCmp('panelOpInfo');
                        strPanelOpInfo.layoutsetActiveItem('noInfo');
                        strDetailPanelOpInfo.hide();
                        strNorthText = Ext.getCmp('northText');
                        strNorthText.update('');                   
                        strNavBtn1.setDisabled('true');
                        strNavBtn2.enable();
                    }
                //in other cases the selected ID will not change and clicks will return to tab's last state
            }
        } // end function

















