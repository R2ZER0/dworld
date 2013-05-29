def options(opt):
        opt.load('compiler_d')

def configure(conf):
        conf.load('compiler_d') 

def build(bld):
        bld.program(
            source=['main.d','cuboid/util/json.d'],
            target='app',
            includes = ['.'],
            
            dflags = ['-g']
        ) 