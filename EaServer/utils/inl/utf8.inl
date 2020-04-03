#pragma once

#include <string>

#include <windows.h>
#include <stringapiset.h>

inline std::string utf8Encode(const std::wstring& wstr)
{
  if (wstr.empty()) return std::string();
  auto sizeNeeded = WideCharToMultiByte(CP_UTF8, 0, &wstr[0], static_cast<int>(wstr.size()),
    nullptr, 0, nullptr, nullptr);
  std::string strTo(sizeNeeded, 0);
  WideCharToMultiByte(CP_UTF8, 0, &wstr[0], static_cast<int>(wstr.size()),
    &strTo[0], sizeNeeded, nullptr, nullptr);
  return strTo;
}

inline std::wstring utf8Decode(const std::string& str)
{
  if (str.empty()) return std::wstring();
  auto sizeNeeded = MultiByteToWideChar(CP_UTF8, 0, &str[0], static_cast<int>(str.size()),
    nullptr, 0);
  std::wstring wstrTo(sizeNeeded, 0);
  MultiByteToWideChar(CP_UTF8, 0, &str[0], static_cast<int>(str.size()),
    &wstrTo[0], sizeNeeded);
  return wstrTo;
}
