// here comes the neighborhood

Ext.onReady(function() {
  
  Ext.ux.LinkButton = Ext.extend(Ext.Button, {
    href: null,
    handler: function() {
      if (this.href) {
	this.target = '_blank';
	window.location.href = this.href;
      }
    } 
  }); 

  Ext.BLANK_IMAGE_URL = '/ext-4.0.0/resources/images/default/s.gif';
  var
    fields = [{'name':'id', 'type':'integer'}],
    columns = [{
      'id': 'id',
      'header': 'index',
      'dataIndex': 'id',
      'flex': 1
    }], 
    abc = 'abcdefghijklmnopqrstuvwxyz';
    
  String.prototype.capitalize = function(){
   return this.replace( /(^|\s)([a-z])/g , function(m,p1,p2){ return p1+p2.toUpperCase(); } );
  };

  for ( var i=0; i<20; i++) {
    var field = 'col_' + abc.charAt(i);
    fields.push({'name': field, 'type': 'string'});
    columns.push({'dataIndex': field, 'header': field.replace(/_/g,' ').capitalize()});
  }
//   
  Ext.define('T20', {
    extend: 'Ext.data.Model',
    fields: fields,
    idProperty: 'id',
    proxy: {
        type: 'ajax',
        url : '/cgi-bin/query.pl',
        reader: {
          type: 'json',
          root: 'data',
          totalProperty: 'count'
        },
    }
  });
// 
  var store = Ext.create('Ext.data.Store', {
    model: 'T20',
    pageSize: 25,
    remoteSort: true,
    autoLoad: true
  });
//  
  
  var grid = Ext.create('Ext.grid.Panel', {
    width: 980,
    height: 650,
    title: 'ExtJS.com - Browse Forums',
    renderTo: 'grid',
    store: store,
    columns: columns,
    title: 'table with 20 fields',

// paging bar on the bottom
    bbar: Ext.create('Ext.PagingToolbar', {
      store: store,
      displayInfo: true,
      displayMsg: 'sorok {0} - {1}, mind {2} ',
      emptyMsg: 'Nincs itt semmi látnivaló',
    }),
  });

  // trigger the data store load
  store.loadPage(1);

  Ext.create('Ext.ux.LinkButton', {
    text: 'Excel Report',
    renderTo: 'report',        
    href: '/cgi-bin/report.pl'
});

});
