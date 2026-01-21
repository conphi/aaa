# 1. 下载文件
wget https://ziglang.org/builds/zig-x86_64-linux-0.16.0-dev.2193+fc517bd01.tar.xz

# 2. 创建安装目录
sudo mkdir -p /opt/zig

# 3. 解压文件并移除多余的层级（--strip-components=1）
sudo tar -xf zig-x86_64-linux-0.16.0-dev.2193+fc517bd01.tar.xz -C /opt/zig --strip-components=1

# 4. (可选) 删除下载的压缩包以节省空间
rm zig-x86_64-linux-0.16.0-dev.2193+fc517bd01.tar.xz

ln -s /opt/zig/zig /usr/local/bin/zig
zig version
#########################################################################################
rm /usr/local/bin/zig
rm -rf /opt/zig
