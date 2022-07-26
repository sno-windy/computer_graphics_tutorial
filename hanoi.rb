
require 'opengl'
require 'glu'
require 'glut'
require 'cg/hanoi_tower'

WSIZE=600       # ウインドウサイズ
SLEEP_TIME=0.5  # stepの実行時間調整
DEFAULT_N=4     # 円盤の枚数(default)

N = (ARGV.size == 0) ? DEFAULT_N : ARGV.shift.to_i
__hanoi=Hanoi.new(N) # ハノイの塔
__from = 0           # 移動元
__to = 1             # 移動先
DISK_RAD = 0.25 / N

def render_bar()
    GL.Color(0.2,0,0)
    x = -0.73
    y = -0.5
    3.times do |i|
        GL.Rect(x, y, x + 0.06, y + 1.0)
        x += 0.7
    end
end

def render_disk(xc, yb, index)
  GL.Color(1.0,0,0)
  GL.Rect(xc - DISK_RAD * index, yb, xc + DISK_RAD * index, yb + 0.1)
end

display = Proc.new {
  GL.Clear(GL::COLOR_BUFFER_BIT) # 背景のクリア

  render_bar()
  towers = __hanoi.towers # 現在の塔のデータを得る
  towers.each_with_index{ |tower, i|
    tower.each_with_index{ |disk, j|
        render_disk(-0.7 + i * 0.7, -0.5 + j * 0.1, disk)
    }
  }

  GLUT.SwapBuffers()
}
######## 以下は変更不要 ########

#### アイドルコールバック ########
idle = Proc.new {
  __hanoi.step          # 1ステップ進める
  if __hanoi.complete?  # 完成した?
    GLUT.IdleFunc(nil)  # アニメーション停止
    __from = __to       # 次の移動元
    __to = (__from+1)%3 # 次の移動先
  end
  sleep(SLEEP_TIME)     # 少し止める
  GLUT.PostRedisplay()
}

#### キーボード入力コールバック ########
keyboard = Proc.new { |key,x,y|
  # [s],[SPACE]で開始(動作中は反応しない)
  if __hanoi.complete? and (key == 's' or key.ord == 0x20)
    __hanoi.setup(__from,__to)     # ハノイの塔を解く準備をする
    GLUT.IdleFunc(idle)            # idle登録(解き始める)
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
GLUT.InitWindowSize(WSIZE,WSIZE)
GLUT.CreateWindow('Tower of Hanoi')
GLUT.DisplayFunc(display)
GLUT.KeyboardFunc(keyboard)
GL.ClearColor(0.4,0.4,1.0,1.0)
GLUT.MainLoop()
