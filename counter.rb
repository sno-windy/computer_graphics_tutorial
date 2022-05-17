# coding: utf-8
require "opengl"
require "glu"
require "glut"
require "cg/mglutils"

##
## データ(定数)
##
WSIZE = 600  # ウインドウサイズ

X1 = -0.3
X2 = -0.2
X3 = 0.2
X4 = 0.3
Y1 = 0.55
Y2 = 0.45
Y3 = 0.05
Y4 = -0.05
Y5 = -0.45
Y6 = -0.55

def createRect(isLight, xl, yt, xr, yb)
  light = isLight ? 1.0 : 0.2
  GL.Color(light, 0, 0)
  GL.Rect(xl, yt, xr, yb)
end

def createNumber(isL1, isL2, isL3, isL4, isL5, isL6, isL7)
  createRect(isL1, X2, Y1, X3, Y2)
  createRect(isL2, X1, Y2, X2, Y3)
  createRect(isL3, X3, Y2, X4, Y3)
  createRect(isL4, X2, Y3, X3, Y4)
  createRect(isL5, X1, Y4, X2, Y5)
  createRect(isL6, X3, Y4, X4, Y5)
  createRect(isL7, X2, Y5, X3, Y6)
end

##
## カウンタ状態変数
##
__number  = 0

display = Proc.new {

  GL.Clear(GL::COLOR_BUFFER_BIT) # 画面のクリア

  ### カウンタの描画　###
  if __number == 0
    createNumber(true, true, true, false, true, true, true)
  elsif __number == 1
    createNumber(false, false, true, false, false, true, false)
  elsif __number == 2
    createNumber(true, false, true, true, true, false, true)
  elsif __number == 3
    createNumber(true, false, true, true, false, true, true)
  elsif __number == 4
    createNumber(false, true, true, true, false, true, false)
  elsif __number == 5
    createNumber(true, true, false, true, false, true, true)
  elsif __number == 6
    createNumber(true, true, false, true, true, true, true)
  elsif __number == 7
    createNumber(true, true, true, false, false, true, false)
  elsif __number == 8
    createNumber(true, true, true, true, true, true, true)
  elsif __number == 9
    createNumber(true, true, true, true, false, true, true)
  end

  GL.Flush() # 描画実行
}

### キーボード入力コールバック ########
keyboard = Proc.new { |key,x,y|
  if key == 'h'
    __number = (__number + 9) % 10
    GLUT.PostRedisplay()
  elsif key == 'l'
    __number = (__number + 1) % 10
    GLUT.PostRedisplay()
  # [q]か[ESC]: 終了する
  elsif key == 'q' or key.ord == 0x1b
    exit 0
  end
}

##############################################
# main
##############################################
GLUT.Init()                         # OpenGLの初期化
GLUT.InitWindowSize(WSIZE,WSIZE)    # ウインドウサイズの指定
GLUT.CreateWindow("Traffic Signal") # ウインドウ作成
GLUT.DisplayFunc(display)           # 描画コールバックの登録
GLUT.KeyboardFunc(keyboard)         # キーボード入力コールバックの登録
GL.ClearColor(0.4,0.4,1.0,1.0)      # 背景色の設定
GLUT.MainLoop()                     # イベントループ開始
