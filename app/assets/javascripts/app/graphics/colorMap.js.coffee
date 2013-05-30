App.ColorMap = {
  fetch: (->
    colors = [
      0x000000,
      0xee0000,
      0x00ee00,
      0x0000ee,
      0xee00ee,
      0xeeee00,
      0x00eeee
    ]

    keys = [null]

    (key) ->
      index = _.indexOf(keys, key)
      if index > -1
        index %= colors.length
      else
        keys.push(key)
        index = (keys.length - 1) % colors.length

      colors[index]
  )()
}
