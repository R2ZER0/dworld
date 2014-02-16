def options(opt):
        opt.load('compiler_d')

def configure(conf):
        conf.load('compiler_d') 

def build(bld):
        bld.program(
            source=['main.d', 'cuboid/world.d', 'cuboid/worldloader.d', 'msgpack.d'],
            target='testapp',
            includes = ['.'],
            lib = ['dyaml', 'dyaml-debug'],
            
            dflags = ['-g']
        )