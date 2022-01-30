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

PS:我的电视小米4A43寸的，广告真是太让人烦，研究了好几天没办法root，后来找了很多资料，终于弄清楚怎么卸载内置应用了，如果完全去广告需要更换桌面，语音功能将会废掉。。。但是真清净。
所以，我们此次的最佳目标就是没有广告还能正常使用语音功能。

开始前需要准备的工具
1，安装刷机大师（卓大师）电脑版 需要使用ADB命令
2，常用的电视软件，雷鸟直播，当贝桌面等。（窃以为作为电视有这2个软件足够了）

好了下面开始卸载工作。
首先，建议恢复出厂状态，请问度娘。
设置电视三项：
关闭更新
打开开发者模式，
打开允许安装应用程序
打开ADB调试




安装常用的软件及其播放必须的插件。
语音搜索西游记，播放，安装云视听极光插件，腾讯视频必须，否则没法播放
语音搜索汪汪队，播放，安装播放插件
安装常用的电视软件，当贝桌面，雷鸟直播等
电脑安装刷机大师，默认路径C:\Program Files(x86)\zhuods。打开电脑cmd命令行
输入命令：cd C:\Program Files (x86)\zhuods 进入ADB目录
输入命令：adb connect 192.168.3.111:5555 ，（电视IP根据实际输入）
此时显示C:\ProgramFiles (x86)\zhuods>adbconnect 192.168.3.111:5555
*daemon not running.starting it now on port 5037 *
*daemon startedsuccessfully *
unableto connect to :5555
输入一条adb命令adb shell pm uninstall--user 0 com.xiaomi.mitv.upgrade
此时显示：C:\ProgramFiles (x86)\zhuods>adbshell pm uninstall --user 0 com.xiaomi.mitv.up
grade
error:device not found
error:device not found
再次输入adbconnect 192.168.3.111:5555
这是电视会出现adb调试选择框，选择一直允许链接的设备调试，电机确定，（如上图）
Cmd界面显示为C:\Program Files (x86)\zhuods>adb connect 192.168.3.111:5555
connectedto192.168.3.111:5555
此时已经成功连接电视，逐条执行下列命令：
（如果想使用电视自带的全部功能只想去广告请直接调至从横线下！）
adb shell pm uninstall--user 0 com.xiaomi.mitv.upgrade
adb shell pm uninstall --user 0 com.xiaomi.account
adb shell pm uninstall --user 0 com.droidlogic
adb shell pm uninstall --user 0 com.xiaomi.mitv.payment
adb shell pm uninstall --user 0 com.xiaomi.upnp
adb shell pm uninstall --user 0 com.xiaomi.mitv.pay
adb shell pm uninstall --user 0 com.xiaomi.tv.appupgrade
adb shell pm uninstall --user 0 com.android.vpndialogs
adb shell pm uninstall --user 0 com.xiaomi.mitv.remotecontroller.service
adb shell pm uninstall --user 0 com.xiaomi.mitv.tvpush.tvpushservice
adb shell pm uninstall --user 0 com.xiaomi.account.auth
adb shell pm uninstall --user 0 com.jiajia.yundonghui.mitv
adb shell pm uninstall --user 0 com.xiaomi.statistic
adb shell pm uninstall --user 0 com.mipay.wallet.tv
adb shell pm uninstall --user 0 com.xiaomi.smarthome.tv
adb shell pm uninstall --user 0 com.xiaomi.mitv.smartshare
adb shell pm uninstall --user 0 com.xiaomi.mitv.appstore
adb shell pm uninstall --user 0 com.xiaomi.milink.udt
adb shell pm uninstall --user 0 com.mi.miplay.mitvupnpsink
adb shell pm uninstall --user 0 com.mi.umifrontend
adb shell pm uninstall --user 0 com.miui.tv.analytics
adb shell pm uninstall --user 0 com.xiaomi.dlnatvservice
adb shell pm uninstall --user 0 com.xiaomi.mitv.assistant.manual
adb shell pm uninstall --user 0 com.xiaomi.mitv.shop
adb shell pm uninstall --user 0 com.xiaomi.devicereport
adb shell pm uninstall --user 0 com.xiaomi.mibox.lockscreen
adb shell pm uninstall --user 0 com.duokan.airkan.tvbox
adb shell pm uninstall --user 0 com.mi.umi
adb shell pm uninstall --user 0 com.xiaomi.gamecenter.sdk.service.mibo
adb shell pm uninstall --user 0 com.android.proxyhandler
adb shell pm uninstall --user 0 com.android.statementservice
adb shell pm uninstall --user 0 com.xiaomi.mitv.advertis
adb shell pm uninstall --user 0 com.android.location.fused
adb shell pm uninstall --user 0 mitv.service
adb shell pm uninstall --user 0 com.xiaomi.mitv.service
adb shell pm uninstall --user 0 com.xiaomi.screenrecorder
adb shell pm uninstall --user 0 com.mitv.screensaver
adb shell pm uninstall --user 0 com.ktcp.tvvideo
------------------------------------------------------------------------------------------------------------------
adb shell pm uninstall--user 0 com.miui.systemAdSolution（广告插件）
adb shell pm uninstall --user 0 com.pptv.tvsports.preinstall（预装应用包括视频头条，体育等）
adb shell pm uninstall --user 0 com.duokan.videodaily（今日头屏）
adb shell pm uninstall --user 0 com.pplive.atv（）
adb shell pm uninstall --user 0 com.xiaomi.mitv.advertise（广告应用）
如果需要小米电视界面，以下命令不可执行，
如果要直接使用当贝桌面等其它第三方桌面，执行以下命令，
adbshell pm uninstall --user 0 com.mitv.tvhome
（删除小米自带桌面，去掉广告的根源，前提是必须提前安装了第三方桌面，否则会无法开机！）
重启电视。
以上横线下删除的应用及其插件在重启后还会再生成，主要由电视桌面程序自动下载并安装。
重启电视机，修改允许ADB调试
进入当贝桌面，设置，

打开电视管家，根据需要删除不需要的软件。
如前，进入cmd命令连接电视，再执行一遍
adb shell pm uninstall--user 0 com.miui.systemAdSolution（广告插件）
adb shell pm uninstall --user 0 com.pptv.tvsports.preinstall（预装应用包括视频头条，体育等）
adb shell pm uninstall --user 0 com.duokan.videodaily（今日头屏）
adb shell pm uninstall --user 0 com.pplive.atv（插件）
adb shell pm uninstall --user 0 com.xiaomi.mitv.advertise（广告应用）
adb shell pm uninstall--user 0 com.xiaomi.mitv.advertise命令，此时广告被彻底去除

最后，阉割安装程序功能（以下命令建议慎用，预装的应用不会自动安装了，其它应用也不能安装）
adb shell pm uninstall --user 0 com.android.defcontainer
执行
重启电视。
完成。

ps，要彻底的去广告就必须不用小米电视自带的桌面，后果是语音功能就不能用了，
如果想在小米的电视界面彻底去广告请参照：
电视管家--深度清理---大文件关机前全部删除下次开机会没有广告！


所有，这台电视很纠结，2G的内存被广告和没用的垃圾充满了。。。。。但是删除自带桌面又可惜了。。
好处就是无论如何，有问题就回复出厂设置。。。

希望以后能出个root方法，这也不是长久之计！
我的策略是从横线下开始执行，最后阉割安装程序功能，世界清静了，以后不再折腾，开机广告关机前清理。。。。如果不购买会员，不使用自带桌面的就从头开始，这样电视内存轻松，速度快。
谢谢大家！
希望对大家有帮助，祝 2018新春快乐！！！
