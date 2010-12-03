/*
 ============================================================================
 Name        : HideRun.c
 Author      : xtiqin 
 Website     : http://plter.com
 Version     :
 Copyright   : Your copyright notice
 ============================================================================
 */


#include <stdio.h>
#include <stdlib.h>
#include <windows.h>


/**
 * 
 * 命令行参数说明,sw delay cmd
 * sw 是否显示窗体
 * delay 延时
 * cmd 要执行的命令
 */
int main(int argc,char** argv) {
	int sw=0;
	char cmdLine[512]="";
	
	if(argc>3){
		sw=strcmp(argv[1],"show")==0?SW_SHOW:SW_HIDE;
		int delay=atoi(argv[2]);
		if(delay>0){
			Sleep(delay);
		}
		
		int i=0;
		for (i = 3; i < argc; ++i) {
			strcat(cmdLine,argv[i]);
			strcat(cmdLine," ");
		}
		
		WinExec(cmdLine,sw);
	}else{
		MessageBoxA(NULL,"Aurgument error","DelayHideRun",MB_OK);
	}
	return EXIT_SUCCESS;
}

