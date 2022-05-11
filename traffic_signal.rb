# coding: utf-8
require "opengl"
require "glu"
require "glut"
require "cg/mglutils"

##
## データ(定数)
##
WSIZE = 600  # ウインドウサイズ

R = 0.2      # ランプ(円板)の半径
M = 0.1      # ランプとランプの間隔，周囲のマージン
W = 6*R+4*M  # フレームの横幅
H = 2*R+2*M  # フレームの高さ
D = 2*R+M    # ランプの中心間の距離

YC = 0.5     # ランプの位置(高さ)
YT = YC+R+M  # フレームの上端
YB = YT-H    # フレームの下端
XL = -W/2    # フレームの左端
XR = XL+W    # フレームの右端
XRP = XL+M   # ポールの右端
YBP = -1.0   # ポールの下端(画面の下端)

L_ON  = 1.00 # ランプ点灯状態の明るさ
L_OFF = 0.5  # ランプ消灯状態の明るさ

##
## 信号状態変数
## 0=GREEN,1=YELLOW,2=RED
##
__lamp  = 0

### 信号機の描画(描画コールバック) ########
display = Proc.new {

  GL.Clear(GL::COLOR_BUFFER_BIT) # 画面のクリア

  ## フレームとポールを描く
  GL.Color(0.7,0.7,0.7)  # 色=グレイ
  GL.Rect(XL,YT,XR,YB)   # フレーム(四角)を描く
  GL.Rect(XL,YB,XRP,YBP) # ポール(四角)を描く

  ## ランプ(円板)を描く(それぞれ中心，半径を指定)
  if __lamp == 0
    ### 緑点灯
    GL.Color(0,L_ON,0);      MGLUtils.disc([-D,YC],R) # ON
    GL.Color(L_OFF,L_OFF,0); MGLUtils.disc([ 0,YC],R) # OFF
    GL.Color(L_OFF,0,0);     MGLUtils.disc([ D,YC],R) # OFF
  elsif __lamp == 1
    ### 黄点灯
    GL.Color(0,L_OFF,0);     MGLUtils.disc([-D,YC],R) # OFF
    GL.Color(L_ON,L_ON,0);   MGLUtils.disc([ 0,YC],R) # ON
    GL.Color(L_OFF,0,0);     MGLUtils.disc([ D,YC],R) # OFF
  else
    ### 赤点灯
    GL.Color(0,L_OFF,0);     MGLUtils.disc([-D,YC],R) # OFF
    GL.Color(L_OFF,L_OFF,0); MGLUtils.disc([ 0,YC],R) # OFF
    GL.Color(L_ON,0,0);      MGLUtils.disc([ D,YC],R) # ON
  end

  GL.Flush() # 描画実行
}

### キーボード入力コールバック ########
keyboard = Proc.new { |key,x,y|
  # <文字>.ord == その<文字>に対応する番号
  # 印字できない文字はこのようにして扱う
  # 印字できる文字でもordで番号と比較できる
  # 文字の番号はirbを使って「ord」で調べられる
  # $ irb
  # irb(main):001:0> 'n'.ord [Enter]
  # => 110
  # irb(main):002:0> exit [Enter]

  # [n]か[SPACE]か[TAB]: 信号を順に切替える
  if key == 'n' or key == ' ' or key.ord == 0x09
    __lamp = (__lamp + 1) % 3 # 0 -> 1, 1 -> 2, 2 -> 0
    GLUT.PostRedisplay()      # displayコールバックを(後で適宜)呼び出す．
  # [q]か[ESC]: 終了する
  elsif key == 'q' or key.ord == 0x1b
    exit 0
  end
}

#### マウス入力コールバック ########
mouse = Proc.new { |button,state,x,y|
  # 左ボタンが押されたら，信号を順に切替える
  if button == GLUT::LEFT_BUTTON and state == GLUT::DOWN
    __lamp = (__lamp + 1) % 3 # 0 -> 1, 1 -> 2, 2 -> 0
    GLUT.PostRedisplay()      # displayコールバックを(後で適宜)呼び出す．
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
GLUT.MouseFunc(mouse)               # マウス入力コールバックの登録
GL.ClearColor(0.4,0.4,1.0,1.0)      # 背景色の設定
GLUT.MainLoop()                     # イベントループ開始
