require 'cg/ncautomaton'

__nca = NCAutomaton.new(ARGV)
exit 1 unless __nca.configured

display = Proc.new {
    GL.Clear(GL::COLOR_BUFFER_BIT)
    __nca.display
    GL.Flush()
}

keyboard = Proc.new { |key, x, y|
    exit0 if key == ?q or key == 0x1b
}

GLUT.Init()
GLUT.InitWindowSize(*__nca.wsize)
GLUT.CreateWindow('a')
GLUT.DisplayFunc(display)
GLUT.KeyboardFunc(keyboard)
GL.ClearColor(1.0, 1.0, 1.0, 0.0)
GLUT.MainLoop()