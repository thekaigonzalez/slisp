OPT=-O2 -march=native -pipe
all: binary
	gdc ./lmathlib.d -shared -fPIC -L-static $(OPT) -o ./libs/math.so
		
	gdc ./linputlib.d -shared -fPIC -L-static $(OPT) -o ./libs/input.so
	gdc ./loslib.d -shared -fPIC -L-static $(OPT) -o ./libs/os.so
	gdc ./external.d -shared -fPIC -L-static $(OPT) -o ./libs/salspec.so
	gdc ./lcurl.d -shared -fPIC -L-static $(OPT) -o ./libs/curl.so


	
binary: 
	gdc ./salmon-impl.d ./sal_builtins.d ./sal_shared_api.d -L-static -o sally

no-std: binary

std: all
