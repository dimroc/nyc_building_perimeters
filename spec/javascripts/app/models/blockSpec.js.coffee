describe "models.block", ->
  describe "Validations", ->
    it "should validate presence of attributes", ->
      expect(App.Block).toValidatePresenceOf("point")

  describe "encoded", ->
    it "should return TRUE when there is a video url", ->
      block = new App.Block(
        point: {},
        video: {url:"exists"}
      )

      expect(block.encoded()).toBeTruthy()

    it "should return FALSE when there is an empty video url", ->
      block = new App.Block(point: {}, video: {url: ""})
      expect(block.encoded()).toBeFalsy()

    it "should return FALSE when there is NOT a video url", ->
      block = new App.Block(point: {}, video: {})
      expect(block.encoded()).toBeFalsy()

    it "should return FALSE when there is no video", ->
      block = new App.Block(point: {})
      expect(block.encoded()).toBeFalsy()
