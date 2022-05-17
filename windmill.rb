# coding: utf-8
require "opengl"
require "glu"
require "glut"

##
## 定数
##
DTHETA = 0.02*Math::PI # 回転角単位
WING_W = 0.7           # 風車の羽根のサイズ(長さ)
WING_H = 0.3           # 風車の羽根のサイズ(幅)
SLEEP_TIME = 0.01      # アニメーションスピード調整パラメタ
WSIZE = 400            # ウインドウサイズ

##
## 状態変数
##
__theta = 0       # 風車の角度
__anim_on = false # アニメーションON/OFF(最初は偽:OFF)

display = Proc.new {

  # 背景のクリア
  GL.Clear(GL::COLOR_BUFFER_BIT)

  # 風車の描画
  GL.Begin(GL::QUADS)

    cos_t = Math.cos(__theta)
    sin_t = Math.sin(__theta)

    x0 = WING_W*cos_t
    y0 = WING_W*sin_t
    x1 = -WING_H*sin_t
    y1 = WING_H*cos_t
    x2 = x0 + x1
    y2 = y0 + y1

    x3 = -WING_W*sin_t
    y3 = WING_W*cos_t
    x4 = -WING_H*cos_t
    y4 = -WING_H*sin_t
    x5 = x3 + x4
    y5 = y3 + y4

    GL.Color(1.0,0.7,0.0)
    GL.Vertex(0.0,0.0)
    GL.Vertex(x0,y0)
    GL.Vertex(x2,y2)
    GL.Vertex(x1,y1)

    GL.Color(1.0,0.4,0.0)
    GL.Vertex(0.0,0.0)
    GL.Vertex(x3,y3)
    GL.Vertex(x5,y5)
    GL.Vertex(x4,y4)
  
    GL.Color(1.0,0.7,0.0)
    GL.Vertex(0.0,0.0)
    GL.Vertex(-x0,-y0)
    GL.Vertex(-x2,-y2)
    GL.Vertex(-x1,-y1)

    GL.Color(1.0,0.4,0.0)
    GL.Vertex(0.0,0.0)
    GL.Vertex(-x3,-y3)
    GL.Vertex(-x5,-y5)
    GL.Vertex(-x4,-y4)

  GL.End()

  #  GL.Flush()      # SINGLEバッファの場合
  GLUT.SwapBuffers() # 2枚のバッファの交換
}

#### アイドルコールバック ########
idle = Proc.new {
  sleep(SLEEP_TIME)          # SLEEP_TIMEだけ待つ
  __theta += DTHETA           # 風車の角度の更新
  GLUT.PostRedisplay()       # displayコールバックを(後で適宜)呼び出す
}

#### キーボード入力コールバック ########
keyboard = Proc.new { |key,x,y| 
  # [r]でアニメーション開始/停止
  if key == 'r'
    if __anim_on           ## アニメーションON(ON->真)の場合
      GLUT.IdleFunc(nil)   # idleコールバックの登録削除(→アニメーション停止)
      __anim_on = false    # アニメーションOFF(ON->偽)
    else                   ## アニメーションOFFの場合
      GLUT.IdleFunc(idle)  # idleコールバックの登録(→アニメーション開始)
      __anim_on = true     # アニメーションON(ON->真)
    end
  # [q]か[ESC]の場合は，終了する．
  elsif key == 'q' or key.ord == 0x1b
    exit 0
  end
}

##############################################
# main
##############################################
GLUT.Init()
GLUT.InitDisplayMode(GLUT::RGB|GLUT::DOUBLE) # ダブルバッファを利用するための設定
GLUT.InitWindowSize(WSIZE,WSIZE) 
GLUT.CreateWindow("Windmill")
GLUT.DisplayFunc(display)        
GLUT.KeyboardFunc(keyboard)      
GL.ClearColor(0.4,0.4,1.0,1.0)   
GLUT.MainLoop()
