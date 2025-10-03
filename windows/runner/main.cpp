#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>
#include <tlhelp32.h>
#include <vector>
#include <string>
#include <thread>
#include <chrono>
#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>
#include <iostream>  // for debug logs

#include "flutter_window.h"
#include "utils.h"

struct VisibilityCheck {
    DWORD processId;
    bool isVisible;
};

bool IsProcessWindowVisible(DWORD processId) {
    VisibilityCheck data = {processId, false};

    EnumWindows([](HWND hwnd, LPARAM lParam) -> BOOL {
        auto *check = reinterpret_cast<VisibilityCheck *>(lParam);
        DWORD pid = 0;
        GetWindowThreadProcessId(hwnd, &pid);
        if (pid == check->processId) {
            if (IsWindowVisible(hwnd) && !IsIconic(hwnd)) {
                check->isVisible = true;
                return FALSE; // Found a visible window — stop
            }
        }
        return TRUE;
    }, reinterpret_cast<LPARAM>(&data));

    return data.isVisible;
}


bool IsActiveScreenSharingAppRunning() {
    std::vector <std::wstring> targets = {
            L"obs64.exe", L"obs32.exe", L"obs.exe", L"obs64bit.exe", L"obs32bit.exe",
            L"Zoom.exe", L"Teams.exe", L"discord.exe", L"Skype.exe", L"SkypeApp.exe",
            L"Snagit32.exe", L"SnagitEditor.exe", L"Snagit.exe", L"CamtasiaStudio.exe",
            L"Camtasia.exe",
            L"screenrecorder.exe", L"screenrecord.exe", L"bandicam.exe", L"vlc.exe",
            L"flashbackrecorder.exe",
            L"ShareX.exe", L"ApowerREC.exe", L"Debut.exe", L"IcecreamScreenRecorder.exe",
            L"Fraps.exe",
            L"CamtasiaRecorder.exe", L"CamtasiaStudio.exe", L"CamtasiaRecorder.exe",
            L"Camtasia.exe",
            L"XSplit.Core.exe", L"XSplitBroadcaster.exe", L"XSplitGamecaster.exe", L"Action.exe",
            L"Dxtory.exe", L"FBRecorder.exe", L"FBPlayer.exe", L"GameBar.exe",
            L"GameBarFTServer.exe",
            L"XboxGameBar.exe", L"XboxGameBarFTServer.exe", L"Screenflick.exe", L"ScreenFlow.exe",
            L"QuickTimePlayer.exe", L"Monosnap.exe", L"Loom.exe", L"CamtasiaStudio.exe",
            L"CamtasiaRecorder.exe",
            L"FlashBackPlayer.exe", L"FlashBackRecorder.exe", L"FlashBackExpress.exe",
            L"ScreenVirtuoso.exe",
            L"TinyTake.exe", L"MovaviScreenRecorder.exe", L"MovaviScreenCapture.exe",
            L"ScreencastOMatic.exe",
            L"Screencast-O-Matic.exe", L"Ezvid.exe", L"ActivePresenter.exe", L"ScreenCam.exe",
            L"ScreenHunter.exe", L"Screenpresso.exe", L"Bandicam.exe", L"CamtasiaStudio.exe",
            L"GoToMeeting.exe", L"BlueJeans.exe", L"Webex.exe", L"WebexHost.exe", L"WebexApp.exe",
            L"GoogleMeet.exe", L"Meet.exe", L"ZoomMeeting.exe", L"ZoomRooms.exe",
            L"AnyDesk.exe", L"TeamViewer.exe", L"UltraViewer.exe", L"RemotePC.exe",
            L"Splashtop.exe",
            L"VNC.exe", L"RealVNC.exe", L"TightVNC.exe", L"TigerVNC.exe",
            L"ChromeRemoteDesktopHost.exe",
            L"mstsc.exe", L"RDCMan.exe", L"RemoteDesktopManager.exe", L"ScreenRecorder.exe",
            L"ScreenCapture.exe", L"ScreenRec.exe", L"ScreenApp.exe", L"Screenity.exe",
            L"Screen Recorder HD.exe", L"Screen Recorder Lite.exe", L"Screen Recorder Studio.exe",
            L"Screen Recorder Robot.exe", L"Screen Recorder Expert.exe",
            L"Screen Recorder Ultimate.exe",
            L"Screen Recorder Plus.exe", L"Screen Recorder Free.exe", L"Screen Recorder Master.exe",
            L"Screen Recorder Professional.exe", L"Screen Recorder Deluxe.exe",
            L"Screen Recorder Premium.exe",
            L"Screen Recorder Advanced.exe", L"Screen Recorder Unlimited.exe",
            L"Screen Recorder Max.exe",
            L"Screen Recorder Elite.exe", L"Screen Recorder Gold.exe",
            L"Screen Recorder Platinum.exe",
            L"Screen Recorder Diamond.exe", L"Screen Recorder Pro X.exe",
            L"Screen Recorder Pro Max.exe",
            // Add more as needed
    };

    HANDLE hSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if (hSnap == INVALID_HANDLE_VALUE) return false;

    PROCESSENTRY32 pe32;
    pe32.dwSize = sizeof(PROCESSENTRY32);

    if (!Process32First(hSnap, &pe32)) {
        CloseHandle(hSnap);
        return false;
    }

    do {
        for (const auto &target: targets) {
            if (_wcsicmp(pe32.szExeFile, target.c_str()) == 0) {
                std::wcout << L"[DEBUG] Found matching process: " << pe32.szExeFile << std::endl;
                DWORD pid = pe32.th32ProcessID;
                if (IsProcessWindowVisible(pid)) {
                    std::wcout << L"[SECURITY] Active window for: " << pe32.szExeFile << std::endl;
                    CloseHandle(hSnap);
                    return true;
                }
            }
        }
    } while (Process32Next(hSnap, &pe32));

    CloseHandle(hSnap);
    return false;
}

int APIENTRY
wWinMain(_In_
HINSTANCE instance, _In_opt_
HINSTANCE prev,
        _In_
wchar_t *command_line, _In_
int show_command
) {
if (!
::AttachConsole(ATTACH_PARENT_PROCESS)
&& ::IsDebuggerPresent()) {
CreateAndAttachConsole();

}

::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED
);

flutter::DartProject project(L"data");
std::vector <std::string> command_line_arguments = GetCommandLineArguments();
project.
set_dart_entrypoint_arguments(std::move(command_line_arguments)
);

Win32Window::Point origin(10, 10);
Win32Window::Size size(1280, 720);

FlutterWindow window(project);
if (!window.Create(L"tedreeb_edu_app", origin, size)) {
return
EXIT_FAILURE;
}

// ✅ Prevent screen capture on Windows
SetWindowDisplayAffinity(window
.

GetHandle(), WDA_MONITOR

);

window.SetQuitOnClose(true);

auto messenger = window.flutter_controller()->engine()->messenger();
auto channel = std::make_unique < flutter::MethodChannel < flutter::EncodableValue >> (
        messenger, "screen_privacy",
                &flutter::StandardMethodCodec::GetInstance());

std::thread([
channel = channel.get()
]() {
bool last_state = false;
while (true) {
bool foundActive = IsActiveScreenSharingAppRunning();
if (foundActive != last_state) {
last_state = foundActive;
if (foundActive) {
std::cout << "[DEBUG] Sending hideApp to Flutter" <<
std::endl;
channel->InvokeMethod("hideApp", nullptr);
} else {
std::cout << "[DEBUG] Sending showApp to Flutter" <<
std::endl;
channel->InvokeMethod("showApp", nullptr);
}
MessageBox(NULL,
L"An active screen sharing or remote access app is running. Please close it to use this application.", L"Security Alert", MB_OK | MB_ICONERROR);
ExitProcess(EXIT_FAILURE);
}

std::this_thread::sleep_for(std::chrono::seconds(2)
);
}
}).

detach();

MSG msg;
while (
GetMessage(&msg, nullptr,
0, 0)) {
TranslateMessage(&msg);
DispatchMessage(&msg);
}

::CoUninitialize();
return
EXIT_SUCCESS;
}
