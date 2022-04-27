# coding: utf-8
require "opengl"
require "glut"
require "cg/mglutils"


# 描画コールバック
display = Proc.new {
   GL.Clear(GL::COLOR_BUFFER_BIT) # 画面をクリアする
   GL.Begin(GL::TRIANGLES)        # 図形プリミティブ(三角形)指定開始
      GL.Color(1.0,0.0,0.0)       # 描画色を設定
      GL.Vertex(-0.9, 0.9)        #   頂点1
      GL.Color(1.0,0.4,0.0)       # 描画色を設定
      GL.Vertex(-0.9,-0.1)        #   頂点2
      GL.Color(1.0,0.8,0.0)       # 描画色を設定
      GL.Vertex( 0.1,-0.1)        #   頂点3
   GL.End()                       # 図形プリミティブ(三角形)指定終了
   GL.Color(0.5,0.8,1.0)          # 描画色を設定
   MGLUtils.disc([0.5,-0.5],0.4)  # 円板を描く
   GL.Flush()                     # 描画強制実行
}

# キーボード入力コールバック
keyboard = Proc.new { |key,x,y|
  exit(0)                         # 何かキーが押されたらプログラム終了
}

GLUT.Init()                       # 初期化処理
GLUT.InitWindowSize(300,300)      # ウインドウの大きさの指定
GLUT.CreateWindow("OpenGL:Test")  # ウインドウの作成
GLUT.DisplayFunc(display)         # 描画コールバック登録
GLUT.KeyboardFunc(keyboard)       # キーボード入力コールバック登録
GL.ClearColor(0.4,0.4,1.0,0.0)    # 背景色の設定
GLUT.MainLoop()                   # イベントループ開始
