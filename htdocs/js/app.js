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

//  Test 1, task 2
  if(Ext.get("grid") ){
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

  // define a table with a loader   
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

  // create a store
    var store = Ext.create('Ext.data.Store', {
      model: 'T20',
      pageSize: 25,
      remoteSort: true,
      autoLoad: true
    });

  // create a grid
    var grid = Ext.create('Ext.grid.Panel', {
      width: 980,
      height: 650,
      title: 'Table browser',
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
  }
  
// test 1, task 3
  if(Ext.get("report")){
    Ext.create('Ext.ux.LinkButton', {
      text: 'Excel Report',
      renderTo: 'report',        
      href: '/cgi-bin/report.pl'
    });
  }
  
// test 2, task 1
  if(Ext.get("toolbar")){
    
  // field set loader
    function clickHandler(item, e) {
      var label = item.text;
      new Ext.get("xhr").load({
        url: '/cgi-bin/page.pl',
        params: { 
          label: label
        },
        scripts: true
      });
    }
    
  // toolbar with menu
    Ext.create('Ext.toolbar.Toolbar', {
      renderTo: 'toolbar',
      items: [
        {
          text: 'first Menu',
          menu: [
            {
                text: 'Menu 1, Item 1',
                handler: clickHandler
            },
            {
                text: 'Menu 1, Item 2',
                handler: clickHandler
            },
            {
                text: 'Menu 1, Item 3',
                handler: clickHandler
            }
          ]
        },
        
        {
          text: 'second Menu',
          menu: [
            {
                text: 'Menu 2, Item 1',
                handler: clickHandler
            },
            {
                text: 'Menu 2, Item 2',
                handler: clickHandler
            },
            {
                text: 'Menu 2, Item 3',
                handler: clickHandler
            }
          ]
        },

        {
          text: 'third Menu',
          menu: [
            {
                text: 'Menu 3, Item 1',
                handler: clickHandler
            },
            {
                text: 'Menu 3, Item 2',
                handler: clickHandler
            },
            {
                text: 'Menu 3, Item 3',
                handler: clickHandler
            }
          ]
        },

        {
          text: 'forth Menu',
          menu: [
            {
                text: 'Menu 4, Item 1',
                handler: clickHandler
            },
            {
                text: 'Menu 4, Item 2',
                handler: clickHandler
            },
            {
                text: 'Menu 4, Item 3',
                handler: clickHandler
            }
          ]
        },

        {
          text: 'fifth Menu',
          menu: [
            {
                text: 'Menu 5, Item 1',
                handler: clickHandler
            },
            {
                text: 'Menu 5, Item 2',
                handler: clickHandler
            },
            {
                text: 'Menu 5, Item 3',
                handler: clickHandler
            }
          ]
        },
    ]
    });
  }
});
