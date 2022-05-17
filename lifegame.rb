# coding: utf-8
require "opengl"
require "glu"
require "glut"
require "cg/lifegame"

N = 64          # ライフゲームのセルの個数(NxN)
SCALE = 8       # セルの表示サイズの係数
WSIZE = N * SCALE # ウインドウの大きさ
RATE = 0.2      # 生命体の初期発生率[0.0-1.0]
SLEEP_TIME=0.1

# ライフゲームの準備
__game = LifeGame.new(N, N, RATE, ARGV.shift)
__anime_on = false

#### 描画コールバック ####
display = Proc.new {
    GL.Clear(GL::COLOR_BUFFER_BIT)
    GL.Color(0.0, 1.0, 0.0)           # 生命体のセルの色(変えてもよい)

    __game.each do |i,j|

    xl = - 1.0 + (2.0 * i.to_f) / N
    xr = xl + 2.0 / N
    yt = 1 - 2.0 * j.to_f / N
    yb = yt - 2.0 / N
    GL.Rect(xl, yt, xr, yb)
  end

  GLUT.SwapBuffers() # バッファの交換(displayの最後に実行)
}

#### アイドルコールバック ####
idle = Proc.new {

    sleep(SLEEP_TIME)          # SLEEP_TIMEだけ待つ
    __game.step           # ライフゲームの更新
    GLUT.PostRedisplay()       # displayコールバックを(後で適宜)呼び出す

}

#### キーボード入力コールバック ####
keyboard = Proc.new { |key,x,y|

    if key == 'r'
        if __anime_on
            GLUT.IdleFunc(nil)
            __anime_on = false
        else
            GLUT.IdleFunc(idle)
            __anime_on = true
        end
    end

    if key == 's'
        __game.step
        GLUT.PostRedisplay() # 再描画
    elsif key == 'q' or key.ord == 0x1b
        exit 0
    end
}

##############################################
# main
##############################################
GLUT.Init()
GLUT.InitDisplayMode(GLUT::RGB|GLUT::DOUBLE)
GLUT.InitWindowSize(WSIZE,WSIZE)
GLUT.CreateWindow("Life Game")
GLUT.DisplayFunc(display)
GLUT.KeyboardFunc(keyboard)
GL.ClearColor(0, 0, 0, 0)
GLUT.MainLoop()
