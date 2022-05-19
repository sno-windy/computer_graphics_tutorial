# coding: utf-8
require 'opengl'
require 'glu'
require 'glut'

##
## 定数
##
DTHETA = 0.02 * Math::PI # 回転角単位
PI2    = 2 * Math::PI    # 2π
PI_3   = Math::PI / 3 # π/3
STAR_R = 0.35          # 六芒星の中心からの遠い方の長さ
SLEEP_TIME = 0.01      # アニメーションスピード調整パラメタ
WSIZE = 400            # ウインドウサイズ

##
## 状態変数
##
__theta = 0       # 六芒星の角度
__anim_on = false # アニメーションON/OFF(最初はOFF)

# (cx, cy): 中心
# r:     六芒星の中心からの遠い方の長さ
# theta:   姿勢

def cos(theta)
    return Math.cos(theta)
end

def sin(theta)
    return Math.sin(theta)
end

def triangle(cx, cy, r, theta)
    random = Random.new
    GL.Color(random.rand(), random.rand(), random.rand())
    GL.Vertex(cx + r * cos(theta), cy + r * sin(theta))
    GL.Vertex(cx + r * cos(theta + PI_3 * 2), cy + r * sin(theta + PI_3 * 2))
    GL.Vertex(cx + r * cos(theta - PI_3 * 2), cy + r * sin(theta - PI_3 * 2))
end

# 六繃星の描画
def star(cx, cy, r, theta)
  GL.Begin(GL::TRIANGLES)
    triangle(cx, cy, r, theta)
    triangle(cx, cy, r, theta + PI_3)
  GL.End()
end

# (x, y)を通る十字線を描くメソッド
# (画面領域は-1 <= x,y <= 1を仮定している)
def grid(x, y)
  GL.Begin(GL::LINES) # 頂点を2つずつつないで(複数の)線分を描く
    GL.Vertex(-1.0, y)
    GL.Vertex(1.0, y)
    GL.Vertex(x, - 1.0)
    GL.Vertex(x, 1.0)
  GL.End()
end

display = Proc.new {
  GL.Clear(GL::COLOR_BUFFER_BIT) # 背景のクリア

  x0,y0 = 0.25, -0.25
  x1,y1 = -0.25, 0.25

  GL.Color(1.0, 1.0, 1.0)
  grid(x0, y0)
  grid(x1, y1)

  star(x0, y0, STAR_R, __theta)
  star(x1, y1, 1.5 * STAR_R, PI_3 - __theta)

  GLUT.SwapBuffers()
}

#### アイドルコールバック ########
idle = Proc.new {
  sleep(SLEEP_TIME)                # SLEEP_TIMEだけ待つ
  __theta = (__theta+DTHETA) % PI2 # 角度の更新
  GLUT.PostRedisplay()             # displayコールバックを(後で適宜)呼び出す
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
GLUT.InitDisplayMode(GLUT::RGB|GLUT::DOUBLE)
GLUT.InitWindowSize(WSIZE, WSIZE)
GLUT.CreateWindow('Star')
GLUT.DisplayFunc(display)
GLUT.KeyboardFunc(keyboard)
GL.ClearColor(1.0, 1.0, 1.0, 1.0)
GLUT.MainLoop()
