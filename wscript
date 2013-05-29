def options(opt):
        opt.load('compiler_d')

def configure(conf):
        conf.load('compiler_d') 

def build(bld):
        bld.program(
            source='main.d',
            target='app',
            use='cuboid',
            includes = ['.'],
            
            dflags = ['-g']
        ) 
        bld.stlib(source='cuboid/util/json.d', target='cuboid') 