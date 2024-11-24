module win32;

import std.utf : toUTF16z;

import core.sys.windows.windows;

ulong initWindow(string appName, uint windowWidth, uint windowHeight)
{
    HINSTANCE hInstance = GetModuleHandle(null);

    WNDCLASS wndclass;
    wndclass.style = CS_HREDRAW | CS_VREDRAW | CS_OWNDC;
    wndclass.lpfnWndProc = &wndProc;
    wndclass.cbClsExtra = 0;
    wndclass.cbWndExtra = 0;
    wndclass.hInstance = hInstance;
    wndclass.hIcon = LoadIcon(null, IDI_APPLICATION);
    wndclass.hCursor = LoadCursor(null, IDC_ARROW);
    wndclass.hbrBackground = cast(HBRUSH) GetStockObject(WHITE_BRUSH);
    wndclass.lpszClassName = appName.toUTF16z;

    if (!RegisterClass(&wndclass))
    {
        MessageBox(null, "This program requires Windows NT!", appName.toUTF16z, MB_ICONERROR);
        return 0;
    }

    DWORD style = WS_OVERLAPPEDWINDOW | WS_CLIPCHILDREN | WS_CLIPSIBLINGS;

    HWND hwnd = CreateWindow(
        appName.toUTF16z,
        appName.toUTF16z,
        style,
        CW_USEDEFAULT,
        0,
        windowWidth,
        windowHeight,
        null,
        null,
        hInstance,
        null);

    ShowWindow(hwnd, SW_SHOWNORMAL);
    UpdateWindow(hwnd);

    MSG msg;
    bool isRunning = true;
    while (isRunning)
    {
        while (PeekMessage(&msg, null, 0, 0, PM_REMOVE))
        {
            TranslateMessage(&msg);
            DispatchMessage(&msg);

            if (msg.message == WM_QUIT)
            {
                isRunning = false;
                break;
            }
        }
    }

    return msg.wParam;
}

extern (Windows)
LRESULT wndProc(HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam) nothrow
{
    scope (failure)
        assert(0);

    switch (message)
    {
    case WM_DESTROY:
        {
            PostQuitMessage(0);
            return 0;
        }

    default:
    }

    return DefWindowProc(hwnd, message, wParam, lParam);
}
