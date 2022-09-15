all: binary
	gdc ./lmathlib.d -shared -fPIC -L-static -o ./libs/math.so
		
	gdc ./linputlib.d -shared -fPIC -L-static -o ./libs/input.so
	gdc ./loslib.d -shared -fPIC -L-static -o ./libs/os.so
	
binary: 
	gdc ./salmon-impl.d ./sal_builtins.d ./sal_shared_api.d -L-static -o sally

no-std: binary

std: all
