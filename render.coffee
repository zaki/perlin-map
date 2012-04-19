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
  imageData = c.getImageData(0, 0, canvas.width, canvas.height)

  date = new Date

  for x in [0..canvas.width]
    for y in [0..canvas.height]
      _x = x / canvas.width
      _y = y / canvas.height
      size = document.getElementById("si").value

      z = (date.getTime() / 50) % 100 * 0.01
      if z > 1.0
        z = 0.5
      n = 255*PerlinNoise.noise(size*_x, size*_y, z)

      hi_treshold = parseInt(document.getElementById("hi").value)
      lo_treshold = parseInt(document.getElementById("lo").value)

      [r, g, b, a] = [25, 125, 25, 255]

      if n > (hi_treshold + 30)
        [r,g,b] = [255, 255, 255]
      else if n > hi_treshold
        [r, g, b] = [n, n, n]
      else if n < lo_treshold
        b = 255
      else if n < lo_treshold + 8
        [r, g, b] = [200, 200, 127]

      i = (x+y*canvas.width)*4
      imageData.data[i+0] = r
      imageData.data[i+1] = g
      imageData.data[i+2] = b
      imageData.data[i+3] = a

  for p in pos
    for _x in [-2..2]
      for _y in [-2..2]
        i = ((_x+p.x)+(_y+p.y)*canvas.width)*4
        imageData.data[i+0] = 255
        imageData.data[i+1] = 0
        imageData.data[i+2] = 0
        imageData.data[i+3] = 255

  c.putImageData(imageData, 0, 0)

  if document.getElementById("ch").checked
    requestAnimFrame(draw)

c = null
pos = []

generate = () ->
  pos = []
  for i in [1..5]
    pos.push { x: parseInt(Math.random()*canvas.width), y: parseInt(Math.random()*canvas.height) }

window.onload = () ->
  canvas = document.getElementById('canvas')
  size = 150
  canvas.width  = size
  canvas.height = size

  c = canvas.getContext('2d')

  document.getElementById("ch").onclick = () =>
    draw(c)
  document.getElementById("su").onclick = () =>
    generate()
    draw(c)

  generate()
  draw(c)
