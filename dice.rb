# coding: utf-8
=begin

所属: 理学部
氏名: 檜垣颯汰
学生番号: 0500308493

提出が遅れてしまい申し訳ございません。課題06:自由制作です。
1 : サイコロが振れるプログラム
2 : t を押すとサイコロを振ることができる。qで終了
3 : 50点
4 : 一瞬でも楽しめるプログラムが良いと思い作成した。
5 : 振られたときにアニメーションがあればなお良いと思う。

=end

# coding: utf-8
require 'opengl'
require 'glu'
require 'glut'
require "cg/mglutils"

WSIZE=600       # ウインドウサイズ
R = 0.04

def render_eye(num)
    case num
    when 1 then
        MGLUtils.disc([0, 0], R)
    when 2 then
        MGLUtils.disc([-0.15, -0.15], R)
    when 3 then
        MGLUtils.disc([0.15, 0.15], R)
    when 4 then
        MGLUtils.disc([-0.15, 0.15], R)
    when 5 then
        MGLUtils.disc([0.15, -0.15], R)
    when 6 then
        MGLUtils.disc([-0.15, 0], R)
    when 7 then
        MGLUtils.disc([0.15, 0], R)
    end
end

def render_eyes(num)
    if num === 1 then
        GL.Color(1.0, 0, 0)
    else
        GL.Color(0, 0, 0)
    end
    case num
    when 1 then
        render_eye(1)
    when 2 then
        render_eye(2)
        render_eye(3)
    when 3 then
        render_eye(1)
        render_eye(2)
        render_eye(3)
    when 4 then
        render_eye(2)
        render_eye(3)
        render_eye(4)
        render_eye(5)
    when 5 then
        render_eye(1)
        render_eye(2)
        render_eye(3)
        render_eye(4)
        render_eye(5)
    when 6 then
        render_eye(2)
        render_eye(3)
        render_eye(4)
        render_eye(5)
        render_eye(6)
        render_eye(7)
    end
end


display = Proc.new {
  GL.Clear(GL::COLOR_BUFFER_BIT) # 背景のクリア
  GL.Color(1.0, 1.0, 1.0)
  GL.Rect(-0.3, -0.3, 0.3, 0.3)
  render_eyes(Random.rand(6.0).ceil)
  GL.Flush() # 描画実行
}

#### キーボード入力コールバック ########
keyboard = Proc.new { |key,x,y|
  if key == 't'
    GLUT.PostRedisplay()
  # [q]か[ESC]の場合は，終了する．
  elsif key == 'q' or key.ord == 0x1b
    exit 0
  end
}

##############################################
# main
##############################################
GLUT.Init()
GLUT.InitWindowSize(WSIZE,WSIZE)
GLUT.CreateWindow('Dice')
GLUT.DisplayFunc(display)
GLUT.KeyboardFunc(keyboard)
GL.ClearColor(0.4,0.4,1.0,1.0)
GLUT.MainLoop()
