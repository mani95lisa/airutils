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

int main(int argc,char** argv) {
	int sw=0;
	char cmdLine[512]="";
	if(argc>1){
		sw=strcmp(argv[1],"show")==0?SW_SHOW:SW_HIDE;
		
		int i=0;
		for (i = 2; i < argc; ++i) {
			strcat(cmdLine,argv[i]);
			strcat(cmdLine," ");
		}
		WinExec(cmdLine,sw);
	}
	return EXIT_SUCCESS;
}
