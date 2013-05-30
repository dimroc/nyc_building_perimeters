# Instantiate test namespaces

jasmine.Fixtures ?= {}
jasmine.Factories ?= {}

window.Fixtures = jasmine.Fixtures
window.Factories = jasmine.Factories

beforeEach ->
  jasmine.Clock.useMock()
  jasmine.Ajax.useMock()

afterEach ->
  teardownSpine()
  clearAjaxRequests()
  $("#jasmine_content").html('')

teardownSpine = ->
  App.World.destroyAll()
  App.Region.destroyAll()
  App.Block.destroyAll()
  delete App.instance

window.initializeSpine = ->
  new App { el: $('#jasmine_content') }

window.loadHtmlFixture = (fixture) ->
  $("#jasmine_content").html(fixture)
