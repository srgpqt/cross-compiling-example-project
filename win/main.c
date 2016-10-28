#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include "../lib/lib.h"

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {
	MessageBox(NULL, TEXT("Hello, World!"), TEXT("Example"), MB_OK | MB_ICONINFORMATION);
}
