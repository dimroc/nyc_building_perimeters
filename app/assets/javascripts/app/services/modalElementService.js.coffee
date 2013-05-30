class App.ModalElementService
  @configure: (el) ->
    #<div id="playBlockModal" class="modal fade hide" tabindex="-1"
    #role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    el.attr('id', 'playBlockModal')
    el.attr('role', 'dialog')
    el.attr('aria-labelledby', 'Block Player')
    el.attr('aria-hidden', 'true')
    el.addClass('modal fade hide')
    el

