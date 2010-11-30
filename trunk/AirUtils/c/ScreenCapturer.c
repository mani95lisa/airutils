
#include <stdio.h>
#include <stdlib.h>
#include <windows.h>

#define MEMORY_ERROR	1
#define PATH_ERROR		2
#define ARGUMENT_ERROR	3

int SaveCapturedBitmap(char *szFilename,HBITMAP hBitmap){
	HDC					hdc=NULL;
	FILE*				fp=NULL;
	LPVOID				pBuf=NULL;
	BITMAPINFO			bmpInfo;
	BITMAPFILEHEADER	bmpFileHeader;
	int state=0;
	do{
		hdc=GetDC(NULL);
		ZeroMemory(&bmpInfo,sizeof(BITMAPINFO));
		bmpInfo.bmiHeader.biSize=sizeof(BITMAPINFOHEADER);
		GetDIBits(hdc,hBitmap,0,0,NULL,&bmpInfo,DIB_RGB_COLORS);

		if(bmpInfo.bmiHeader.biSizeImage<=0)
			bmpInfo.bmiHeader.biSizeImage=bmpInfo.bmiHeader.biWidth*abs(bmpInfo.bmiHeader.biHeight)*(bmpInfo.bmiHeader.biBitCount+7)/8;

		if((pBuf=malloc(bmpInfo.bmiHeader.biSizeImage))==NULL)
		{
			MessageBoxA(NULL,"Unable to Allocate Bitmap Memory","Error",MB_OK|MB_ICONERROR);
			state=MEMORY_ERROR;
			break;
		}

		bmpInfo.bmiHeader.biCompression=BI_RGB;
		GetDIBits(hdc,hBitmap,0,bmpInfo.bmiHeader.biHeight,pBuf,&bmpInfo,DIB_RGB_COLORS);	

		if((fp=fopen(szFilename,"wb"))==NULL)
		{
			MessageBoxA(NULL,"Unable to Create Bitmap File","Error",MB_OK|MB_ICONERROR);
			state= PATH_ERROR;
			break;
		}

		bmpFileHeader.bfReserved1=0;
		bmpFileHeader.bfReserved2=0;
		bmpFileHeader.bfSize=sizeof(BITMAPFILEHEADER)+sizeof(BITMAPINFOHEADER)+bmpInfo.bmiHeader.biSizeImage;
		bmpFileHeader.bfType=0x4D42;
		bmpFileHeader.bfOffBits=sizeof(BITMAPFILEHEADER)+sizeof(BITMAPINFOHEADER);

		fwrite(&bmpFileHeader,sizeof(BITMAPFILEHEADER),1,fp);
		fwrite(&bmpInfo.bmiHeader,sizeof(BITMAPINFOHEADER),1,fp);
		fwrite(pBuf,bmpInfo.bmiHeader.biSizeImage,1,fp);
	}while(FALSE);

	if(hdc){
		ReleaseDC(NULL,hdc);
	}

	if(pBuf){
		free(pBuf);
	}

	if(fp){
		fclose(fp);
	}
	
	return state;
}


int main(int argc,char** argv){
	if(argc!=2){
		MessageBoxA(NULL,"Argument Error","",MB_OK);
		return ARGUMENT_ERROR;
	}

	int nScreenWidth = GetSystemMetrics(SM_CXSCREEN);
	int nScreenHeight = GetSystemMetrics(SM_CYSCREEN);

	printf("%d %d",nScreenWidth,nScreenHeight);
	HWND hDesktopWnd = GetDesktopWindow();
	HDC hDesktopDC = GetDC(hDesktopWnd);
	HDC hCaptureDC = CreateCompatibleDC(hDesktopDC);
	HBITMAP hCaptureBitmap =CreateCompatibleBitmap(hDesktopDC, nScreenWidth, nScreenHeight);
	SelectObject(hCaptureDC,hCaptureBitmap); 
	BitBlt(hCaptureDC,0,0,nScreenWidth,nScreenHeight,hDesktopDC,0,0,SRCCOPY|CAPTUREBLT); 
	int captureState=SaveCapturedBitmap(argv[1],hCaptureBitmap);

	ReleaseDC(hDesktopWnd,hDesktopDC);
	DeleteDC(hCaptureDC);
	DeleteObject(hCaptureBitmap);

	return captureState;
}
