Gfx = {}
Gfx.waves = {}
Gfx.baseY = 30
Gfx.waveWidth = 20
Gfx.waveHeight = 30

function Gfx.createWaves()
  local s = math.sin(Counters.getFrame() / (1/params:get("nearWavesSpeed")))/2 + 0.5;

  for i=0,3 do
    if math.random() > s then
      Gfx.addWave(math.random(-30, 158))
    end
  end

  --print(tab.count(Gfx.waves))
end

function Gfx.display()
  local f = Counters.getFrame()

  -- near waves
  for i,w in ipairs(Gfx.waves) do
    if w ~= nil then
      -- draw waves and remove old ones
      Gfx.removeWave(i, Gfx.drawWave(w, f, i))
    end
  end

  -- foam
  local fL = 3 * math.log(params:get("foamAmp"))
  for n = 0,fL*math.sin(f / (2.4 / params:get("nearWavesSpeed")) - 1.8) do
    y = math.random(60, 63)
    Gfx.setLevel(y)
    screen.pixel(math.random(0, 127), y)
    screen.fill()
  end
end

function Gfx.drawWave(wave, frame, index)
  local x = wave[1]
  local f = frame - wave[2]

  local u = fn.mapToUnity((f / (1.5/params:get("nearWavesSpeed"))), 0, Gfx.waveHeight)
  local dy = u*u -- distance-based vertical offset
  local ay = u * math.sin(x + (f / (2.4/params:get("nearWavesSpeed")))) -- distance-based wave amplitude
  local xw = u*u*u * Gfx.waveWidth * math.sin(f / 100 + x) -- distance-based wave width
  local xx = (params:get("nearWavesAmp")/3) * u * math.sin(dy + ay + (f / (10/params:get("nearWavesSpeed")))) -- distance-based horizontal slew
  local ty = dy * Gfx.waveHeight + Gfx.baseY + ay -- total y

  screen.move(xx + x - (xw/2), ty)
  screen.line_rel(xw + 1, 0)
  Gfx.setLevel(ty)
  screen.stroke()

  return ty
end

function Gfx.addWave(x)
  local f = Counters.getFrame()
  local n = 1+tab.count(Gfx.waves)

  for i = 1,n do
    -- find empty spot
    if Gfx.waves[i] == nil then
      Gfx.waves[i] = {x, f}
    end
  end
end
-- deprecated
function Gfx.clearWaves()
  local f = Counters.getFrame()

  for i,wave in ipairs(Gfx.waves) do
    if f - wave[2] > 8/params:get("nearWavesSpeed") then
      table.remove(Gfx.waves, i)
    end
  end
end

function Gfx.removeWave(i, y)
  if y > Gfx.baseY+Gfx.waveHeight-1 then
    table.remove(Gfx.waves, i)
  end
end

function Gfx.setLevel(y)
  level = 1
  if     y > 60 then level = 13
  elseif y > 56 then level = 8
  elseif y > 50 then level = 5
  elseif y > 42 then level = 3
  elseif y > 30 then level = 2
  end
  screen.level(level)
end

return Gfx
