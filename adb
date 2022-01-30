https://post.smzdm.com/p/axl325l3/


Android TV操作系统版本，遥控器点5下OK按钮
移除默认桌面
pm disable-user --user 0 com.dangbei.TVHomeLauncher


################################################
列出所有应用 adb shell pm list packages
列出系统应用 adb shell pm list packages -s
列出第三方应用 adb shell pm list packages -3
列出已禁用应用 adb shell pm list packages -d
列出已启用应用 adb shell pm list packages -e


###########################################
Performing Push Install adb: error: failed to get feature set: device offline

adb devices
adb kill-server
####################################
