# coding: utf-8
require "opengl"
require "glu"
require "glut"

WSIZE=600     # 画面サイズ
W = 0.5       # 一色の領域の幅
LEFT = -3*W/2 # 旗の左端(旗のx方向の中心が画面中心になるように)

# 描画コールバック(このコールバックを書き換える)
display = Proc.new {
  GL.Clear(GL::COLOR_BUFFER_BIT) # 背景のクリア
  GL.Begin(GL::QUADS)            # 図形プリミティブ(四角形の集合)指定開始

    y0 = W; y1 = -W       # 旗の上端と下端
    x0 = LEFT; x1 = x0+W  # 青の領域の左端と右端
    GL.Color(0.000,0.125,0.624)
    GL.Vertex(x0,y0); GL.Vertex(x0,y1); GL.Vertex(x1,y1); GL.Vertex(x1,y0)

    x0 = x1; x1 = x0+W    # 白の領域の左端と右端
    GL.Color(1.0,1.0,1.0)
    GL.Vertex(x0,y0); GL.Vertex(x0,y1); GL.Vertex(x1,y1); GL.Vertex(x1,y0)

    x0 = x1; x1 = x0+W    # 赤の領域の左端と右端
    GL.Color(0.957,0.165,0.255)
    GL.Vertex(x0,y0); GL.Vertex(x0,y1); GL.Vertex(x1,y1); GL.Vertex(x1,y0)

  GL.End()   # 図形プリミティブ(四角形の集合)指定終了
  GL.Flush() # 描画強制実行
}

# キーボード入力コールバック
keyboard = Proc.new { |key,x,y|
  exit 0                          # 何かキーが押されたらプログラム終了
}

GLUT.Init()                       # 初期化処理
GLUT.InitWindowSize(WSIZE,WSIZE)  # ウインドウの大きさの指定
GLUT.CreateWindow("Tricolore")    # ウインドウの作成
GLUT.DisplayFunc(display)         # 描画コールバック登録
GLUT.KeyboardFunc(keyboard)       # キーボード入力コールバック登録
GL.ClearColor(0.0, 0.0, 0.0, 0.0) # 背景色を設定
GLUT.MainLoop()                   # イベントループ開始
