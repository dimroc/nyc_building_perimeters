beforeEach ->
  @addMatchers({
    toBeAnAction: () ->
      Helpers.getTypeName(@actual.isActive) == "Function"
      Helpers.getTypeName(@actual.activate) == "Function"
      Helpers.getTypeName(@actual.deactivate) == "Function"

    toValidatePresenceOf: (attribute) ->
      @message = -> "Expected Spine Model to validate the presence of #{attribute}"
      instance = new @actual()
      instance.save() == false && _.has(instance.validate(), attribute)
  })
