pico-8 cartridge // http://www.pico-8.com
version 42
__lua__

local px = 63
local py = 112
local bt = {}
local btime = 0
local mtime = 0
local mtime_max = 20
local mdir = 0
local mt = {}
local mgap = 8

local s = 0
local l = 3
local go = false

function _init()
    r1 = {
        y = 8,
        ms = {}
    }
    add(mt, r1)
    add(r1.ms, {x = 16, n = 3})
    add(r1.ms, {x = 32, n = 2})
    add(r1.ms, {x = 48, n = 3})
    add(r1.ms, {x = 64, n = 3})
    add(r1.ms, {x = 80, n = 3})
    add(r1.ms, {x = 96, n = 2})
    add(r1.ms, {x = 112, n = 3})
end

function _update()
    if go then
        return
    end 
    
  if l <= 0 then
    go = true
  end 

  btime = btime + 1
  ms = max(2, flr(2*(s/10)))
  mtime = mtime + ms
  mdir = mdir + 1

  if btn(0) and px > 0 then
    px = px - 1
  end

  if btn(1) and px < 119 then
    px = px + 1
  end
  
  if btime > 5 and (btn(4) or btn(5)) then
    add(bt,{x = px+4, y = py})
    btime = 0
  end
  
  for b in all(bt) do
    b.y = b.y - 1
    if b.y < 0 then
      del(bt, b)
    end

    for rs in all(mt) do
        for m in all (rs.ms) do

            if b.x > m.x and b.x < m.x + 8 and b.y > rs.y and b.y < rs.y + 8 then
                del(rs.ms, m)
                del(bt, b)
                s = s + 1
            end
        end 
    end
  end

  if mtime >= mtime_max then
    if mdir < 30 then
        for rs in all(mt) do
            for m in all (rs.ms) do
                m.x = m.x + 1
            end
            rs.y = rs.y + 1
        end
    elseif mdir >= 30 and mdir < 60 then
        for rs in all(mt) do
            for m in all (rs.ms) do
                m.x = m.x - 1
            end
            rs.y = rs.y + 1
        end
    end
    mtime = 0
  end 

  for rs in all(mt) do
    for m in all (rs.ms) do
        if rs.y > 119 then
            l = l - 1
            del(rs.ms, m)
        end
    end
  end
  
  if mdir > 60 then
    mdir = 0
  end

  if mt[#mt].y > 24 then
    add(mt, {y = 8, ms = {}})
    add(mt[#mt].ms, {x = 16, n = flr(rnd(3))+2})
    add(mt[#mt].ms, {x = 32, n = flr(rnd(3))+2})
    add(mt[#mt].ms, {x = 48, n = flr(rnd(3))+2})
    add(mt[#mt].ms, {x = 64, n = flr(rnd(3))+2})
    add(mt[#mt].ms, {x = 80, n = flr(rnd(3))+2})
    add(mt[#mt].ms, {x = 96, n = flr(rnd(3))+2})
    add(mt[#mt].ms, {x = 112, n = flr(rnd(3))+2})
  end 

end

function _draw()
  if go then
    cls()
    print("game over", 1, 1)
    print("score: " .. s, 1, 8)
    if btn(4) or btn(5) then
      go = false
      l = 3
      bt = {}
      mt = {}
      add(mt, {y = 8, ms = {}})
      add(mt[#mt].ms, {x = 16, n = 3})
      add(mt[#mt].ms, {x = 32, n = 2})
      add(mt[#mt].ms, {x = 48, n = 3})
      add(mt[#mt].ms, {x = 64, n = 3})
      add(mt[#mt].ms, {x = 80, n = 3})
      add(mt[#mt].ms, {x = 96, n = 2})

      s = 0
      mtime = 0
      mdir = 0
      btime = 0
    end
  else 
    cls()
    print("score: " .. s, 1, 1)
    print("lives: " .. l, 1, 8)
    for i = 0, 1 do
        spr(1, px, py + i)
    end
    for b in all(bt) do
        pset(b.x, b.y, 7)
    end
    for rs in all(mt) do
        for m in all (rs.ms) do
            spr(m.n, m.x, rs.y)
        end
    end
  end 
end

__gfx__
000000000006600000300300bbb00bbb0e00e00e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000770000030030000b00b000aeeeea00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000067760033933933002bb200ee00e0e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000677776008333380bbb00bbb0eeeeee00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000006776677600333300b0bbbb0bee00e0ee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000007779677700300300b00b0b0b0eeeeee00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000007776677703300330b00b0b0b00e00e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000870078003000030000b0b000e0000e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
