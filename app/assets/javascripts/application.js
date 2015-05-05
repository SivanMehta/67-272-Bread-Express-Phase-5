// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require_tree .
//*= require materialize

  $(function(){
    $(function(){
      $(".dropdown-button").dropdown({ constrain_width: false });
      $('select').material_select();
    });
  });

$(document).ready(function() {
    $('select').material_select();
  });

$(".button-collapse").sideNav();

$(document).ready(function(){
$('ul.tabs').tabs();
});
       

$(document).ready(function(){
  $('ul.tabs').tabs('select_tab', 'tab_id');
}); 


$(document).ready(function(){
  // the "href" attribute of .modal-trigger must specify the modal ID that wants to be triggered
  $('.modal-trigger').leanModal();

$('.datepicker').pickadate({
    selectMonths: true, // Creates a dropdown to control month
    selectYears: 15 // Creates a dropdown of 15 years to control year
  });
    
});