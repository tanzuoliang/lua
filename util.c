#include <stdio.h>

//因为Lua是C的函数，而我们的程序是C++的，所以要使用extern "C"引入头文件
#include "lua/lua.h"
#include "lua/lualib.h"
#include "lua/lauxlib.h"
#include "lua/luaconf.h"


//int luaopen_mylib(lua_State* L);
// -I (include path file) 
//gcc /usr/local/lib/liblua.a -shared -fPIC -o util.so util.c
static int lua_hello(lua_State* L){
	lua_pushfstring(L, "from c");
	printf("c function11 \n");
	return 1;
}
static int lua_add(lua_State*L){
	int a = lua_tointeger(L, 1);
	int b = lua_tointeger(L, 2);
	printf(" a = %d , b = %d\n",a,b);
	lua_pushinteger(L, a + b);
	return 1;
}


int luaopen_util(lua_State* L){
	printf("c function \n");
	
	static const luaL_Reg mylib[]={
		{"lua_hello",lua_hello},
		{"add",lua_add},
		{NULL,NULL}
	};
	lua_newtable(L); 
	luaL_setfuncs(L,mylib,0);
//	luaL_loadlib();
	
	
	lua_State* LL = luaL_newstate();
	luaopen_base(LL);
	luaL_dofile(LL,"st02.lua");
	lua_getglobal(LL,"add");
	lua_pushinteger(LL,12);
	lua_pushinteger(LL,15);
	lua_pcall(LL,2,1,0);
	printf("result is %lld \n",lua_tointeger(LL,-1));
	printf("result is %lld \n",lua_tointeger(LL,-1));
	printf("result is %lld \n",lua_tointeger(LL,-1));
	
	return 1; 
}