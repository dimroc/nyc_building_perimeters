//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require vendor
//
//= require_tree ./initializers
//= require app
//= require_tree ./bootstrap

$(function() {
  if($("#spine").exists()) {
    new App({el: $('#spine')});
  }
});
