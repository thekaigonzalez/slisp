all: binary
	gdc ./lmathlib.d -shared -fPIC -o ./libs/math.so
	
	gdc ./linputlib.d -shared -fPIC -o ./libs/input.so
	gdc ./loslib.d -shared -fPIC -o ./libs/os.so
	
binary: 
	gdc ./salmon-impl.d ./sal_builtins.d ./sal_shared_api.d -o sally

no-std: binary

std: all
