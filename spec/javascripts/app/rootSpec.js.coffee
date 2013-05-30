describe "controllers.root", ->
  rootController = null

  beforeEach ->
    initializeSpine()
    rootController = App.instance.rootController

  it "should have the correct routes", ->
    expect(rootController.splash).toBeAnAction()
    expect(rootController.regionsIndex).toBeAnAction()
    expect(rootController.regionsShow).toBeAnAction()
