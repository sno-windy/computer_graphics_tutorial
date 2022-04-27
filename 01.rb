require "opengl"
require "glu"
require "glut"
require "cg/mglutils"

WSIZE=600 # ウインドウサイズ
W = 0.5       # 一色の領域の幅
LEFT = -3*W/2 # 旗の左端(旗のx方向の中心が画面中心になるように)

# 描画処理
display = Proc.new {
  GL.Clear(GL::COLOR_BUFFER_BIT) # 背景のクリア

  GL.Begin(GL::QUADS)            # 図形プリミティブ(四角形の集合)指定開始

    y0 = W; y1 = -W
    x0 = LEFT; x1 = -LEFT
    GL.Color(1.0,1.0,1.0)
    GL.Vertex(x0,y0); GL.Vertex(x0,y1); GL.Vertex(x1,y1); GL.Vertex(x1,y0)

    GL.Color(0.957,0.165,0.255)
    MGLUtils.disc([0, 0], W)

  GL.End()   # 図形プリミティブ(四角形の集合)指定終了

  GL.Flush() # 描画強制実行
}

keyboard = Proc.new { |key,x,y|
  exit 0                         # 何かキーが押されたらプログラム終了
}

GLUT.Init()                      # 初期化処理
GLUT.InitWindowSize(WSIZE,WSIZE) # ウインドウの大きさの指定
GLUT.CreateWindow("TITLE")       # ウインドウの作成
GLUT.DisplayFunc(display)        # 描画コールバック登録
GLUT.KeyboardFunc(keyboard)      # キーボード入力コールバック登録
GL.ClearColor(0.0,0.0,0.0,1.0)   # 背景色(R,G,B,A) Aの値は気にしなくてよい
GLUT.MainLoop()                  # イベントループ開始
