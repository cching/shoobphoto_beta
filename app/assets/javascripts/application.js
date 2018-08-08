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
//= require jquery.minicolors
//= require jquery.minicolors.simple_form
//= require jquery.webcam
//= require jquery_ujs
//= require jquery-ui
//= require jquery.easing
//= require jquery.remotipart
//= require jquery.ui.touch-punch
//= require bootstrap.min
//= require moment
//= require bootstrap-datetimepicker
//= require select2-full
//= require pickers
//= require stickyfill
//= require garlic
//= require john_hancock
//= require_tree .



$('.btn-loading').button();

$(document).ready(function(){
  $('.btn-loading').click(function() {
    $(this).button('loading');
  });

    $("#students_list").on("click", ".pagination a", function(){
      $("#students_list").html("");
      $.getScript(this.href);
      return false;
    });

    $('#students_search input').keyup(function () {
      $("#students_list").html("");
      delay(function(){
        $.get($('#students_search').attr('action'), 
          $('#students_search').serialize(), null, 'script');
        
      }, 1000 );
    return false;
  });

    $('#students_search select').bind("change keyup", function(event){
    $.get($('#students_search').attr('action'), 
      $('#students_search').serialize(), null, 'script');
    $("#students_list").html("");
    return false;
  });


  var delay = (function(){
    var timer = 0;
    return function(callback, ms){
      clearTimeout (timer);
      timer = setTimeout(callback, ms);
    };
  })();

});




