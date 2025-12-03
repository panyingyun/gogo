# Fyne GUI 示例

## 编译要求

Fyne 需要 CGO 支持，编译前请确保：

### Windows
1. **启用 CGO**：设置环境变量 `CGO_ENABLED=1`
2. **安装 C 编译器**：
   - 推荐：安装 [TDM-GCC](https://jmeubank.github.io/tdm-gcc/) 或 [MinGW-w64](https://www.mingw-w64.org/)
   - 确保编译器在 PATH 环境变量中

### 编译方法

**方法 1：使用构建脚本（推荐）**
```bash
# Windows
build.bat

# Linux/Mac
chmod +x build.sh
./build.sh
```

**方法 2：手动编译**
```bash
# Windows PowerShell
$env:CGO_ENABLED=1
go build main.go

# Windows CMD
set CGO_ENABLED=1
go build main.go

# Linux/Mac
CGO_ENABLED=1 go build main.go
```

## 错误解决

如果遇到 `build constraints exclude all Go files` 错误：
- 确保 `CGO_ENABLED=1`
- 确保已安装 C 编译器
- 确保 C 编译器在 PATH 中（可通过 `gcc --version` 验证）

