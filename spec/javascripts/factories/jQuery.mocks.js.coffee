Factories.$mockEvent = ($object) ->
  mockEvent = jasmine.createSpyObj("Mock$Event", ["preventDefault", "target"])
  mockEvent.target.andReturn($object)
  return mockEvent
