all:
	gdc ./lmathlib.d -shared -fPIC -o ./libs/math.so
	
	gdc ./linputlib.d -shared -fPIC -o ./libs/input.so
	gdc ./salmon-impl.d ./sal_builtins.d ./sal_shared_api.d -o sally
