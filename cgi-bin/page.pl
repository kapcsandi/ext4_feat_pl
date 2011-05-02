#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;

my $r = new CGI;
my $label = $r->param('label');
my $page = <<END;
<script>
Ext.get('page').update('');
Ext.create('Ext.form.Panel', {
  title: 'Fieldset for this menu item: $label',
  labelWidth: 75, // label settings here cascade unless overridden
  url: '',
  frame: true,
  bodyStyle: 'padding:5px 5px 0',
  width: 550,
  renderTo: 'page',
  layout: 'column', // arrange fieldsets side by side
  defaults: {
    bodyPadding: 4
  },
  items: [{
    // Fieldset in Column 1 - collapsible via toggle button
    xtype:'fieldset',
    columnWidth: 0.5,
    title: 'Fieldset 1',
    collapsible: true,
    defaultType: 'textfield',
    defaults: {anchor: '100%'},
    layout: 'anchor',
    items :[{
      fieldLabel: '$label',
      name: 'field_menu'
    }, {
      fieldLabel: 'Field 1',
      name: 'field1'
    }, {
      fieldLabel: 'Field 2',
      name: 'field2'
    }]
  }]
});
</script>
END

print $r->header('application/javascript');
print $page
