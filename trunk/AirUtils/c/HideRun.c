//+---------------------------------------------------------------------------
//
//  HELLO_WIN.C - Windows GUI 'Hello World!' Example
//
//+---------------------------------------------------------------------------

#include <windows.h>

int APIENTRY WinMain(
				HINSTANCE hInstance,
				HINSTANCE hPrevInstance,
				LPSTR     lpCmdLine,
				int       nCmdShow)
{
	WinExec(lpCmdLine,SW_HIDE);
	return 1;
}