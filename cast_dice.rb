require 'opengl'
require 'glu'
require 'glut'
require 'cg/rotate3d' # カメラを回転移動させるためのパッケージ
require 'cg/gldice'   # さいころを描くためのパッケージ

#### 定数
SZ = 1.0  # サイコロのサイズを決めるパラメタ

DT = 4
MIN_DIST   = 4.0  # カメラの原点からの距離の最小値
INIT_DIST  = 8.0  # カメラの原点からの距離の初期値
DD = 0.125        # カメラの原点からの距離変更の単位
MAX_DIST = 30.0   # 最大距離
SLEEP_TIME = 0.04

FOV = 45.0           # 視野角
NEAR = 0.1           # 視点から手前のクリップ面までの距離
FAR  = 2.0*MAX_DIST  # 視点から奥のクリップ面までの距離

WSIZE = 600          # ウインドウサイズ

#### 状態変数
__theta = 0  # カメラ中心位置(視点)の経度(degree)
__phi = 0     # カメラ中心位置(視点)の緯度(degree)
__psi = 0      # カメラの上方向 ( 視線方向を軸とするカメラの回転角(degree))
__dist = INIT_DIST # カメラの原点からの距離
__dice = GLDice.new(SZ) # サイコロ
__anim_on = false
__counter = 0
__RAND = rand(6)
__RAND_2 = rand(4)
__RAND_3 = rand(6)


#### 経度と緯度からカメラの配置を決定する ########
def set_camera(theta,phi,psi,dist)

  # カメラ位置の決定
  eye = [0.0,0.0,dist]
  eye.rotate3d('x',phi)
  eye.rotate3d('y',theta)

  # カメラの上向きの方向を決定
  up = [0.0,1.0,0.0]
  up.rotate3d('z',psi)
  up.rotate3d('x',phi)
  up.rotate3d('y',theta)

  # カメラの位置と姿勢の指定
  # (カメラは常に原点を追いかけるものとする)
  GL.LoadIdentity()
  GLU.LookAt(eye[0],eye[1],eye[2],0.0,0.0,0.0,up[0],up[1],up[2])
end

#### 描画コールバック ########
display = Proc.new {
  # 背景，Zバッファのクリア
  GL.Clear(GL::COLOR_BUFFER_BIT|GL::DEPTH_BUFFER_BIT)

  ### サイコロを描く
  # サイコロ自体は動かさない
  # (カメラの位置と向きを変えて面の見え方を変える)
  __dice.draw

  GLUT.SwapBuffers()
}

#### アイドルコールバック ########
idle = Proc.new {
  sleep(SLEEP_TIME)

  if __counter < 10
    __theta += 6 * __RAND
    __phi += 5 * __RAND_2
    __psi += 5 * __RAND_3
    __dist += 1
    __counter += 1
  elsif __counter < 15
    __theta += 6 * __RAND
    __phi += 8 * __RAND_2
    __psi += 8 * __RAND_3
    __dist -= 2
    __counter += 1
  else
    __counter = 0
    __RAND = rand(6)
    __RAND_2 = rand(4)
    __RAND_3 = rand(6)
    __anim_on = false
    GLUT.IdleFunc(nil)
  end

  # __theta,__phi,__psiを適宜変更すれば，カメラの配置が変わって
  # サイコロが回転しているように見えるようになる
  set_camera(__theta,__phi,__psi,__dist) # カメラの配置
  GLUT.PostRedisplay()      # 再描画

}

#### キーボード入力コールバック ########
keyboard = Proc.new { |key,x,y|

  # [j],[J]: 経度の正方向/逆方向にカメラを移動する
  if key == 's'
    if __anim_on
        GLUT.IdleFunc(nil)
        __anim_on = false
      else
        GLUT.IdleFunc(idle)
        __anim_on = true
      end
  elsif key == 'q' or key.ord == 0x1b
    exit 0
  end

  set_camera(__theta,__phi,__psi,__dist) # カメラの配置
  GLUT.PostRedisplay()
}

#### ウインドウサイズ変更コールバック ########
reshape = Proc.new { |w,h|
  GL.Viewport(0,0,w,h)

  GL.MatrixMode(GL::PROJECTION)
  GL.LoadIdentity()
  GLU.Perspective(FOV,w.to_f/h,NEAR,FAR)
  GL.MatrixMode(GL::MODELVIEW)

  GLUT.PostRedisplay()
}

##############################################
# main
##############################################

GLUT.Init()

# ダブルバッファリングとZバッファを使うように設定する
GLUT.InitDisplayMode(GLUT::RGB|GLUT::DOUBLE|GLUT::DEPTH)
GLUT.InitWindowSize(WSIZE,WSIZE)
GLUT.CreateWindow('Dice')

GLUT.DisplayFunc(display)
GLUT.KeyboardFunc(keyboard)
GLUT.ReshapeFunc(reshape)
GL.ClearColor(0.4,0.4,1.0,0.0)

# Zバッファ機能をONにする
GL.Enable(GL::DEPTH_TEST)
set_camera(__theta,__phi,__psi,__dist)    # カメラの配置

GLUT.MainLoop()
