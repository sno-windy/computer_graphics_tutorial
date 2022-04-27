# -*- coding: utf-8 -*-
require 'opengl'
require 'glut'

WSIZE=600 # 画面サイズ

SZ=0.5 # ボタンのサイズ
SZ_2=SZ/2
Gap = 0.1
Margin = 0.05

# 描画コールバック(このコールバックを書き換える)
display = Proc.new {
  GL.Clear(GL::COLOR_BUFFER_BIT) # 背景のクリア

  # 基準となる座標の設定
  x0 = -SZ_2; x1 = SZ_2
  y0 = Gap+Margin; y1 = y0 + SZ; y2 = Gap

  GL.Begin(GL::TRIANGLES)        # 図形プリミティブ(三角形の集合)指定開始

  # 上向きボタン
  GL.Color(0.2,1.0,0.3)
  GL.Vertex(x1,y0)
  GL.Vertex(0,y1)
  GL.Vertex(x0,y0)

  # 下向きボタン
  GL.Color(1.0,0.3,0.2)
  GL.Vertex(x1,-y0)
  GL.Vertex(0,-y1)
  GL.Vertex(x0,-y0)

  GL.End()   # 図形プリミティブ(三角形の集合)指定終了

  GL.Begin(GL::QUADS) # 図形プリミティブ(四角形の集合)指定開始
  GL.Color(0.8,0.9,0.2)
  GL.Vertex(x1,-y2)
  GL.Vertex(x1,y2)
  GL.Vertex(x0,y2)
  GL.Vertex(x0,-y2)
  GL.End()            # 図形プリミティブ(四角形の集合)指定終了

  GL.Flush() # 描画強制実行
}

# キーボード入力コールバック
keyboard = Proc.new { |key,x,y|
  exit 0                          # 何かキーが押されたらプログラム終了
}

GLUT.Init()                        # 初期化処理
GLUT.InitWindowSize(WSIZE,WSIZE)   # ウインドウの大きさの指定
GLUT.CreateWindow('Up-Down Arrow') # ウインドウの作成
GLUT.DisplayFunc(display)         # 描画コールバック登録
GLUT.KeyboardFunc(keyboard)       # キーボード入力コールバック登録
GL.ClearColor(0.0, 0.0, 0.0, 0.0) # 背景色を設定
GLUT.MainLoop()                   # イベントループ開始
