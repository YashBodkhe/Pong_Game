window={}
window.width=800
window.height=600
-----------
set=0
----------------------------
player1score=0
player2score=0
----------player 1 (paddle 1)

------------- gamestate -----------
gamestate='start'
----------------------------

--------------------------
serving_Player=1
--------------------------
player1={}
player1.height=50
player1.width=10
player1.x=0
player1.y=window.height/2-(player1.height/2) ----> the ratio will always constant
player1.speed=500
-----player 2 (paddle 2)
player2={}
player2.height=50
player2.width=10
player2.x=(window.width)-(player2.width)
player2.y=window.height/2-(player2.height/2) ----> the ratio will always constant
player2.speed=500
------------------------------------
function collision(x1,y1,w1,h1,x2,y2,w2,h2)
  return x1<x2+w2 and
         x1+w1>x2 and
         y1<y2+h2 and
         y1+h1>y2
 end
----------------- ball -------------------
function create_ball()
  ball={}
  ball.height=12
  ball.width=12
  ball.x=(window.width/2)-(ball.width/2)
  ball.y=(window.height/2)-(ball.height/2)
  ball.xspeed=math.random(400,500)
  ball.yspeed=math.random(400,500)
  --ball.serve=math.random(0,100)
  if(serving_Player==1)then
    ball.xspeed=-ball.xspeed
  elseif(serving_Player==2)then
    ball.speed=ball.xspeed
  end
end
function love.resize(wd,wh)
  window.width=wd
  window.height=wh
  --love.window.setMode(window.width,window.height,{resizable=true})
  player1={}
  player1.height=50
  player1.width=10
  player1.x=0
  player1.y=window.height/2-(player1.height/2) ----> the ratio will always constant
  player1.speed=500
  -----player 2 (paddle 2)
  player2={}
  player2.height=50
  player2.width=10
  player2.x=(window.width)-(player2.width)
  player2.y=window.height/2-(player2.height/2) ----> the ratio will always constant
  player2.speed=500
end

--------------------------------------------------------------------
function love.load()
  love.window.setMode(window.width,window.height,{resizable=true})
  love.graphics.setFont(love.graphics.newFont(22))
  explosion=love.audio.newSource("Explosion4.wav","stream")
  Paddlehit=love.audio.newSource("Paddlehit.wav","stream")
  Point=love.audio.newSource("point.wav","stream")
  Boundary=love.audio.newSource("Boundaryhit.wav","stream")
  love.window.setTitle("Pong_Game_In_Lua")
end
-----------------------------------------------------------------------
-----------------------------------------------------------------------
function love.update(dt)

  if(love.keyboard.isDown('w'))then
    player1.y=player1.y-player1.speed*dt
elseif(love.keyboard.isDown('s'))then
  player1.y=player1.y+player1.speed*dt
end
if(love.keyboard.isDown('up'))then
  player2.y=player2.y-player2.speed*dt
elseif(love.keyboard.isDown('down'))then
  player2.y=player2.y+player2.speed*dt
end
 paddle_boundry_check(player1)
 paddle_boundry_check(player2)


 if(set==1)then
   if(ball.x<0)then
     love.audio.play(Point)
     player2score=player2score+1
     gamestate='serve'
     serving_Player=2
     set=0
   elseif(ball.x>window.width)then
     love.audio.play(Point)
     player1score=player1score+1
     gamestate='serve'
     serving_Player=1
     set=0
   end
 end

------ball movement------
if(set==1)then
ball_boundry_check()
--x_boundry_check()
paddle_ball_collision(player1)
paddle_ball_collision(player2)
ball.x=ball.x+ball.xspeed*dt
ball.y=ball.y+ball.yspeed*dt
end

if(player1score==10 or player2score==10)then
  gamestate='start'
  --set=0
end
end
--------- function boundry check
function paddle_boundry_check(player)
  if(player.y<0)then
  --  love.audio.play(Boundary)
    player.y=0
    --love.audio.play(Boundary)
  elseif(player.y>window.height-player.height)then
  --  love.audio.play(Boundary)
    player.y=window.height-player.height
    --love.audio.play(Boundary)
end
end
function love.keypressed(key)
  if(key=='space')then
  if gamestate == 'start' then
       player1score=0
       player2score=0
       gamestate='serve'
  elseif gamestate == 'serve' then
        gamestate = 'play'
      end

  if(gamestate=='play')then

    create_ball()
    gamestate='In_Playing_mode'
    set=1
  end
end
  if(key=='escape')then
    love.event.quit()
  end

end
------------------------------------------------------------
function ball_boundry_check()
  if(ball.y<0)then
    love.audio.play(Boundary)
    ball.y=0
    ball.yspeed=-ball.yspeed
  elseif(ball.y+ball.height>window.height)then
      love.audio.play(Boundary)
    ball.y=window.height-ball.height
    ball.yspeed=-ball.yspeed
  end
end
----------
--function x_boundry_check()
  --if(ball.x<0)then
--  set=0
----elseif(ball.x>window.width) then
---  set=0
--end
--end
--------------------------------------------------------------
---------------------------------------------------------------
function paddle_ball_collision(player)
if(collision(ball.x,ball.y,ball.width,ball.height,player.x,player.y,player.width,player.height))then
  love.audio.play(Paddlehit)
  ball.xspeed=-ball.xspeed
  if(ball.x<player1.width) then
    ball.x=player1.width
  else
    ball.x=player2.x-ball.width
  end
end
end
----------------------------------------------------------------
----------------------------------------------------------------
function love.draw()

  love.graphics.setBackgroundColor(0.1,0.2,0.2)
  love.graphics.setColor(1,1,1)
  love.graphics.rectangle("fill",player1.x,player1.y,player1.width,player1.height,5)
  love.graphics.rectangle("fill",player2.x,player2.y,player2.width,player2.height,5)
  love.graphics.print(player1score,window.width/2-50,window.height/2)
  love.graphics.print(player2score,window.width/2+50,window.height/2)
  love.graphics.setFont(love.graphics.newFont(15))
  if(gamestate=='start')then
    love.graphics.printf("Welcome To Pong Game",0,20,window.width,'center')
    love.graphics.printf("By Yash Bodkhe (GameDevUtopia)!!",0,60,window.width,'center')
    love.graphics.printf("Press Spacebar to Continue",0,100,window.width,'center')
  elseif(gamestate =='serve') then
    love.graphics.setFont(love.graphics.newFont(15))
    love.graphics.printf("Match of 10 Points", 0, 20,window.width,'center')
    love.graphics.printf("Use W,S for Player1", 0, 60,window.width,'center')
    love.graphics.printf("Use Up,Down for Player2", 0, 100,window.width,'center')
    love.graphics.printf("Press Spacebar to Start Game!", 0, 140,window.width,'center')
  end
    love.graphics.setFont(love.graphics.newFont(22))


  --love.graphics.print(gamestate,window.width/2+100,window.height/3)
--  love.graphics.print(gamestate,window.width/2+100,window.height/4)
  if(player1score==10)then
    love.graphics.print("Winner!!",window.width/2-200,window.height/2)
    love.graphics.print("Loser!!",window.width/2+130,window.height/2)
  end
  if(player2score==10)then
    love.graphics.print("Loser!!",window.width/2-200,window.height/2)
    love.graphics.print("Winner!!",window.width/2+130,window.height/2)
  end

  --- drawing the create_ball
    love.graphics.setColor(0,1,1)
  if(set==1)then
  love.graphics.rectangle("fill", ball.x, ball.y, ball.width, ball.height,50)
end
end
