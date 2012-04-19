requestAnimFrame =
      window.requestAnimationFrame ||
      window.webkitRequestAnimationFrame ||
      window.mozRequestAnimationFrame ||
      window.oRequestAnimationFrame ||
      window.msRequestAnimationFrame ||
      ((callback, element) ->
        window.setTimeout(callback, 1000/60)
      )

draw = () ->
  for x in [0..canvas.width/10]
    for y in [0..canvas.height/10]
      tile = map[x+y*(canvas.width/10)][0]
      vars = map[x+y*(canvas.width/10)][1]

      if tile == 1
        vars -= 0.1
        if vars < 0
          vars = 4
        map[x+y*(canvas.width/10)][1] = vars

      c.drawImage(sprites, vars*10, tile*10, 10, 10, x*10, y*10, 10, 10)

  for p in pos
    [x, y, v] = [p.x, p.y, p.v]

    if map[x+y*(canvas.width/10)][0] != 1
      c.drawImage(sprites, v*10, 50, 10, 10, x*10, y*10, 10, 10)

  if document.getElementById("ch").checked
    requestAnimFrame(draw)

c = null
pos = []

map = []
sprites = new Image
sprites.src = "map_sprites.png"

generate = () ->
  pos = []
  for i in [1..5]
    pos.push { x: parseInt(Math.random()*canvas.width/10), y: parseInt(Math.random()*canvas.height/10), v:parseInt(Math.random()*4) }

  date = new Date

  for x in [0..canvas.width/10]
    for y in [0..canvas.height/10]
      _x = x / canvas.width * 15
      _y = y / canvas.height * 15
      size = document.getElementById("si").value

      z = (date.getTime() / 50) % 100 * 0.01
      if z > 1.0
        z = 0.5
      n = 255*PerlinNoise.noise(size*_x, size*_y, z)
      console.log n

      hi_treshold = parseInt(document.getElementById("hi").value)
      lo_treshold = parseInt(document.getElementById("lo").value)

      [r, g, b, a] = [25, 125, 25, 255]

      map_i = y*(canvas.width/10) + x
      v     = parseInt(Math.random()*5)
      if n > (hi_treshold + 30)
        map[map_i] = [4, v]
      else if n > hi_treshold
        map[map_i] = [3, v]
      else if n < lo_treshold
        map[map_i] = [1, v]
      else if n < lo_treshold + 8
        map[map_i] = [2, v]
      else
        map[map_i] = [0, v]

window.onload = () ->
  canvas = document.getElementById('canvas')
  size = 75
  canvas.width  = size*10
  canvas.height = size*10

  c = canvas.getContext('2d')

  document.getElementById("ch").onclick = () =>
    draw(c)
  document.getElementById("su").onclick = () =>
    generate()
    draw(c)

  generate()
  draw(c)
