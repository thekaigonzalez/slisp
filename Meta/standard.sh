gdc sbase64.d -lsalmon -o base64.so -shared -fPIC
mkdir ./libs &> /dev/null
mv base64.so ./libs