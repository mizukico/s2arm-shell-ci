# s2arm-shell-ci

在 GitHub Actions 的 macOS runner（`xcode-27`）上**只编 S2Arm 的 iOS 壳**（含 Metal host），
不带游戏、不需要 `prod.keys`。用于「宿主 Metal 层要改」的验证（FFR 招式粒子）。

## 我为什么不能直接给你建仓库

我这台机器上没有 `gh`、也没有你的 GitHub 凭据，建不了仓库、也推不了代码。仓库建好后把这三个文件放进去即可。

## 建仓库

```bash
cd s2arm-shell-ci
gh repo create s2arm-shell-ci --private --source=. --push
```

没有 `gh`：网页 New repository（建议私有）→ 上传这三个文件，`.github/workflows/build-shell.yml` 的路径不能变。

## 跑之前注意

1. **runner 标签**：workflow 里是 `runs-on: xcode-27`（和你 `mizukico/Bayo3-T` 那个成功 run 一致）。报 “no runner matching labels” 就换成你账号里带 Xcode 27 的标签。
2. **SDK 主版本**：`pack/shell_build.sh` 只比主版本，`tools/toolchain.env` 钉的是 `IPHONEOS_SDK_MAJOR=27`。workflow 会先打印并核对 `xcrun --sdk iphoneos --show-sdk-version`。
3. **git 必须干净**：`shell_build.sh` 对 `pack/stage_inputs/shell.tsv` 里的文件做 `git status --porcelain` 检查；补丁由 workflow 在 runner 内 `git add -A && git commit` 落成一笔提交，再出壳。
4. **别传游戏/密钥**：编壳完全不需要。

## 第一次：先验链路（不打补丁）

| 输入 | 值 |
|---|---|
| `s2arm_repo` | `jhaizhou-ops/S2Arm` |
| `s2arm_ref` | `main` |
| `patch_in_repo` | 留空 |

成功会产出 `s2arm-shell` artifact（约 120 MB：`root/` + `manifest.json`），不改任何行为。

## 第二次：带 host 补丁 `hostfix/nvn_tbuf_align.patch`

补丁针对 **`graphics/nvn/gfx/nvn/nvn_mtl.m`**（FFR 走的 NVN→Metal 宿主）。
早先那版 `gal_tex.m` 补丁打错了层——实机日志里 FFR 全程是 `[dm] [nvn-mtl]`，`gal_tex.m` 是另一条渲染路径，已删除。

**实机证据**（15:36 / 15:51 两局）：

```
[dm] [nvn-mtl] buffer texture at pool offset 0xc8, below Metal's reported 16-byte alignment: created there
[dm] [nvn-mtl] buffer texture at pool offset 0x200008, below Metal's reported 16-byte alignment: created there
```

`nvn_mtl.m` 对「偏移不是 16 的倍数、但按元素对齐」的贴图缓冲视图是**直接在不达标偏移上建视图**（注释里的依据是 M6 实测）。nxnative 在 M4 上实测这种视图会从下面那个 16 字节边界读、元素全错；A19 Pro 还没人测。FFR 的粒子属性缓冲正好落在这种偏移上——读错元素就会出现「蓝色/绿色柱状、随视角闪烁」。

补丁做三件事：

- `tba_ent` 加 `plain` 标记，`tba_find` 按它区分「2D 行副本」与「整段副本」；
- 新增 `tpa_copy`（GPU 时间线上把整段元素拷进 frame arena，256 字节对齐）与 `tpa_view`（在副本偏移 0 上建只读 `texture_buffer` 视图）；
- `tba_prepare` 在每次 draw / dispatch 前，对反射里 `NVN_RB_TBUF` / `NVN_RB_TBUFU` / `NVN_RB_TEXD`（texture buffer）的未对齐贴图缓冲先做副本；绑定处两处（普通 buffer 槽、动态句柄数组）改用对齐视图。

已验证：`git apply --check` 对 `jhaizhou-ops/S2Arm@main` 的 `nvn_mtl.m` 干净通过（+51 / −7）。

**没有真机验证过**；第一次跑就是编译验证。失败会打印 `【红】make ios 失败` 和第一条 `error:`，把那一两行发我。

触发参数：

| 输入 | 值 |
|---|---|
| `s2arm_repo` | `jhaizhou-ops/S2Arm` |
| `s2arm_ref` | `main` |
| `patch_in_repo` | `hostfix/nvn_tbuf_align.patch` |

## 拿到产物后（Windows 侧）

1. 备份 `E:\ProjectIOS\S2Arm\Shell`（`fix-backup-*` 里还有一份）；
2. 用 artifact 的 `root/` + `manifest.json` 覆盖 `Shell\` 下同名内容（**两者必须成套**，manifest 是 sha256/size/shellId）；
3. `s2armctl build 0100B8A026F14000 ios` 重出包——壳变了只重装配资源，**不会重译 7.3 万支着色器**；
4. `s2armctl install 0100B8A026F14000` 装机，看序章路边火焰与第一/第二场战斗。

## 如果换壳后还是不对

补丁只动「未对齐池偏移」这一处。实机日志里还有一类：

```
audit #1534 P1-20 probe: shader ... stage 5 image slot 0 declares Metal type 9 class 0,
  bound texture is type 9, Metal format 53 (class 1); class differs
```

即 compute 核把 `texture_buffer<float, access::write>` 绑在 uint / sint 格式的缓冲上（数值类不同）。
如果柱状/闪烁仍在，下一步是让翻译器按描述符真实格式声明 image 的数值类——那条在本地就能重出库验证，不用 GHA。
