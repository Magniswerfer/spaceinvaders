pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- game constant
local MONSTER_MOVE_COOLDOWN_THRESHOLD = 20

-- player
local player_pos_x = 63
local player_pos_y = 112

-- bullets
local bullet_table = {}
local bullet_cooldown = 0
local bullet_threshold = 5

-- monster
local monster_move_cooldown = 0
local monster_direction_cooldown = 0
local monster_table = {}

-- game
local score = 0
local lives = 3
local game_over = false

function _init()
  r1 = {
    y = 8,
    ms = {}
  }
  add(monster_table, r1)
  add(r1.ms, { x = 16, n = 3 })
  add(r1.ms, { x = 32, n = 2 })
  add(r1.ms, { x = 48, n = 3 })
  add(r1.ms, { x = 64, n = 3 })
  add(r1.ms, { x = 80, n = 3 })
  add(r1.ms, { x = 96, n = 2 })
  add(r1.ms, { x = 112, n = 3 })
end

function _update()
  check_gameover()

  check_lives()

  bullet_cooldown += 1

  local monster_speed = max(2, flr(2 * (score / 10)))
  monster_move_cooldown = monster_move_cooldown + monster_speed
  monster_direction_cooldown = monster_direction_cooldown + 1

  read_player_input()

  check_bullet_monster_collision()
  check_monster_screen_collision()

  move_bullets()

  move_monsters()

  reset_monster_move_timer()

  procedurally_add_monsters()
end

function _draw()
  if game_over then
    cls()
    print("game over", 1, 1)
    print("score: " .. score, 1, 8)
    restart_game()
  else
    cls()
    print("score: " .. score, 1, 1)
    print("lives: " .. lives, 1, 8)
    spr(1, player_pos_x, player_pos_y)
    for b in all(bullet_table) do
      pset(b.x, b.y, 7)
    end
    for rs in all(monster_table) do
      for m in all(rs.ms) do
        spr(m.n, m.x, rs.y)
      end
    end
  end
end

--------------------------------------------------------
-------               INPUT                      -------
--------------------------------------------------------

function read_player_input()
  if btn(0) then
    move_player_left()
  end

  if btn(1) then
    move_player_right()
  end

  if (btn(4) or btn(5)) and bullet_cooldown >= bullet_threshold then
    shoot_bullet()
    bullet_cooldown = 0
  end
end

function move_player_left()
  player_pos_x = player_pos_x - 1
end

function move_player_right()
  player_pos_x = player_pos_x + 1
end

function shoot_bullet()
  add(bullet_table, { x = player_pos_x + 4, y = player_pos_y })
end

function move_bullets()
  for bullet in all(bullet_table) do
    bullet.y = bullet.y - 1
    if bullet.y < 0 then
      del(bullet_table, bullet)
    end
  end
end

function move_monsters()
  if monster_move_cooldown >= MONSTER_MOVE_COOLDOWN_THRESHOLD then
    if monster_direction_cooldown < 30 then
      for rs in all(monster_table) do
        for m in all(rs.ms) do
          m.x = m.x + 1
        end
        rs.y = rs.y + 1
      end
    elseif monster_direction_cooldown >= 30 and monster_direction_cooldown < 60 then
      for rs in all(monster_table) do
        for m in all(rs.ms) do
          m.x = m.x - 1
        end
        rs.y = rs.y + 1
      end
    end
    monster_move_cooldown = 0
  end
end

--------------------------------------------------------
-------               COLLISSION                 -------
--------------------------------------------------------

function check_bullet_monster_collision()
  for b in all(bullet_table) do
    for row in all(monster_table) do
      for monster in all(row.ms) do
        if b.x > monster.x and b.x < monster.x + 8 and b.y > row.y and b.y < row.y + 8 then
          del(row.ms, monster)
          del(bullet_table, b)
          score = score + 1
        end
      end
    end
  end
end

function check_monster_screen_collision()
  for rs in all(monster_table) do
    for m in all(rs.ms) do
      if rs.y > 119 then
        lives = lives - 1
        del(rs.ms, m)
      end
    end
  end
end

function reset_monster_move_timer()
  if monster_direction_cooldown > 60 then
    monster_direction_cooldown = 0
  end
end

function procedurally_add_monsters()
  if monster_table[#monster_table].y > 24 then
    add(monster_table, { y = 8, ms = {} })
    add(monster_table[#monster_table].ms, { x = 16, n = flr(rnd(3)) + 2 })
    add(monster_table[#monster_table].ms, { x = 32, n = flr(rnd(3)) + 2 })
    add(monster_table[#monster_table].ms, { x = 48, n = flr(rnd(3)) + 2 })
    add(monster_table[#monster_table].ms, { x = 64, n = flr(rnd(3)) + 2 })
    add(monster_table[#monster_table].ms, { x = 80, n = flr(rnd(3)) + 2 })
    add(monster_table[#monster_table].ms, { x = 96, n = flr(rnd(3)) + 2 })
    add(monster_table[#monster_table].ms, { x = 112, n = flr(rnd(3)) + 2 })
  end
end

function check_gameover()
  if game_over then
    return
  end
end

function check_lives()
  if lives <= 0 then
    game_over = true
  end
end

function restart_game()
  if btn(4) or btn(5) then
    game_over = false
    lives = 3
    bullet_table = {}
    monster_table = {}
    add(monster_table, { y = 8, ms = {} })
    add(monster_table[#monster_table].ms, { x = 16, n = 3 })
    add(monster_table[#monster_table].ms, { x = 32, n = 2 })
    add(monster_table[#monster_table].ms, { x = 48, n = 3 })
    add(monster_table[#monster_table].ms, { x = 64, n = 3 })
    add(monster_table[#monster_table].ms, { x = 80, n = 3 })
    add(monster_table[#monster_table].ms, { x = 96, n = 2 })

    score = 0
    monster_move_cooldown = 0
    mdir = 0
    bullet_cooldown = 0
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
