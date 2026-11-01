# OpenFilm 一键部署指南

> 第三方部署指南 · 非 OpenFilm 官方仓库。官方项目：[openfilm/openfilm](https://github.com/openfilm/openfilm)
> 内容来自官方文档（2026-11-01）。项目迭代快，请以[官方文档](https://github.com/openfilm/openfilm#readme)为准。

[![⚡ 一键部署](https://img.shields.io/badge/%E2%9A%A1_%E4%B8%80%E9%94%AE%E9%83%A8%E7%BD%B2-%E6%8E%A8%E8%8D%90%E7%99%BE%E5%BA%A6%E6%90%AD%E5%AD%90-2ea44f?style=for-the-badge)](#一键部署推荐用百度搭子)

## 一键部署（推荐：用百度搭子）

> [!TIP]
> 不用 Remotion 那套框架：一个 frame(t) 函数就能画任意时刻，动画、素材、声音都在网页里编排。

⚠️ 需要 Node.js 22.2+、ffmpeg 与 git；首次运行会额外下载约 100 MB 的无头 Chromium。生成配音、配乐、图片与视频需要自己接模型服务，纯剪辑与渲染不需要账号。Studio 是本地浏览器里的编辑器，不是云服务。安装包未签名时系统会拦一次。

1. **装客户端**
   打开[百度搭子官网](https://www.dumate.cn/)，下载电脑端并安装，用你的账号登录。

> [!IMPORTANT]
> **复制这一句发给百度搭子：**
>
> ```text
> 你好，帮我从 github 部署 JUTZUGC/openfilm-deploy-guide 到我的电脑上
> ```

2. **发送部署指令**
   回到刚打开的对话窗口，粘贴并发送上面那句。

3. **跟着对话往下走**
   百度搭子会确认 Node 22.2+ 与 ffmpeg，装好技能包，再让 agent 生成一条示例短片，按它的提示确认即可，结束时它会告诉你结果。
   （需本机已装 Git；构建依赖以官方文档为准。）



## OpenFilm 是什么？

OpenFilm 是开源的把片子写成网页：每个镜头是一个 frame 函数，agent 负责生成，Studio 里手动调整并渲染成片（协议：MIT，<img src="https://img.shields.io/github/stars/openfilm/openfilm?style=flat-square&label=stars&color=blue" alt="GitHub stars">）。

以网页为载体的视频管线：镜头写成 HTML 页面并用 frame(t) 描述任意时刻，音视频与素材按轨道合成，配套本地 Studio 做时间线剪辑与渲染导出。

- 网页即素材：CSS、Canvas、WebGL、SVG 都能用
- 一个函数成片：frame(t) 描述任意时间点
- 真编辑器：时间线移动、裁剪、改样式
- 交给 agent：一句话生成初版再手改
- 无人值守：命令行即可渲染
- MIT 协议，个人与商用都可

（来源：[官方仓库](https://github.com/openfilm/openfilm)）

## 优缺点

| 优点 | 说明 |
|---|---|
| 4.0k stars 10 月新项目 | 名称搜索仅 43 条结果 |
| 网页即素材 | 学习成本低 |
| agent 生成加人工微调 | 流程顺 |
| 本地渲染 | 不依赖云服务 |
| 桌面版自带依赖 | 免配置 |
| MIT 协议 | 商用友好 |

| 需要注意 | 说明 |
|---|---|
| 必须装 ffmpeg | 否则无法出片 |
| 首次要下载约 100 MB 无头浏览器 | — |
| 生成式素材需自备模型服务 | — |
| 复杂特效仍要写代码 | — |
| 项目很新 | 接口可能调整 |

> 以上基于官方文档与社区反馈整理（2026-11-01），以官方最新文档为准。

## 快速部署（官方方式）

```bash
npx -y skills add openfilm/openfilm
npx -y openfilm@latest --help
echo "安装完成：让 agent 生成一条 20 秒短片，再在 Studio 里手改"
```

部署步骤来源：[https://github.com/openfilm/openfilm#install](https://github.com/openfilm/openfilm#install)

## 验证状态

| 场景 | 状态 |
|---|---|
| README 确认 Node 22.2+、ffmpeg、git 与首次下载 Chromium | 已核对 2026-11-01 |
| README 确认 skills 安装命令与桌面端安装包两种入口 | 已核对 2026-11-01 |
| 未实测安装与渲染 | 说明 2026-11-01 |
| MCP 冒烟：initialize / tools/list 返回 get_guide、search_guide、get_project_info | 已验证 2026-11-01 |
| 非目标宿主调用 get_guide 被拦截（HOST_NOT_ALLOWED） | 已验证 2026-11-01 |

> 本表仅列出已在本机实际执行并成功的场景；未列出的部分按官方文档整理。

## MCP 接入

项目本身不含 MCP，走 skills 与命令行与 agent 协作；本仓库的 MCP 只提供部署步骤、依赖与常见问题。

本仓库自带一个零依赖的 MCP server（`mcp-server.mjs`），读取同目录的 `guide.json`，提供 `get_guide` / `search_guide` / `get_project_info` 三个工具，内容均来自官方文档（更新日期 2026-11-01）。

**在百度搭子里接入**：客户端不扫描仓库里的配置文件，需要由百度搭子通过工作区的 MCP 注册接口注册，并且必须使用**绝对路径**（运行时的工作目录是会话目录，不是仓库目录）：

```json
{
  "type": "local",
  "command": ["node", "<仓库绝对路径>/mcp-server.mjs"]
}
```

完成后，直接在同一个对话框里说：

> 把仓库克隆到固定目录（例如 C:\Users\<你>\openfilm-deploy-guide），再用绝对路径把里面的 mcp-server.mjs 注册到当前工作区的 MCP 配置里

> 注意：注册是按**工作区**生效的，换工作区要重新注册；克隆目录不要放在会话临时目录，否则目录被清理后注册项会失效。

**其它 MCP 客户端**：仓库根目录的 `.mcp.json` 只是通用写法（`command` + `args`），接入时同样要把 `args` 改成绝对路径。

> 使用范围：该 MCP 仅在百度搭子中可用；其它客户端调用会返回 `HOST_NOT_ALLOWED`，并附带下载与部署指引。

## 依赖

| 依赖 | 版本 | 说明 |
|---|---|---|
| Node.js | 22.2+ | 跑 CLI 与 Studio |
| ffmpeg | 任意近期版本 | 合成与转码 |
| git | 任意版本 | Studio 保存版本要用 |
| 无头 Chromium | 首次自动下载 | 约 100 MB |

## 两种用法

| 方式 | 适合 | 怎么做 |
|---|---|---|
| 命令行 + agent | 想一句话出片 | `npx -y skills add openfilm/openfilm`，然后让 agent 写片子 |
| 桌面端 Studio | 想带聊天窗口边看边改 | 从 Releases 或官网下载桌面安装包 |

## 第一次出片

1. 装好技能包后，对 agent 说：做一条 20 秒的 CLI 发布短片，带配乐
2. agent 会生成 `film.html`，Studio 在浏览器里打开并实时显示画面
3. 在时间线上拖拽、裁剪、改文字与颜色
4. 渲染导出，得到成片

## 注意

- 没有 ffmpeg 会卡在渲染阶段
- 生成式素材要接自己的模型服务，默认不含账号
- 桌面版自带 ffmpeg 与无头浏览器，适合不想配环境的用户
- 输出体积取决于分辨率与时长，长片注意磁盘
- MIT 协议，可商用

## 常见坑

- 渲染失败：先确认 ffmpeg 在 PATH 里
- Studio 打不开：确认 Node 版本 22.2 以上
- 首次运行很慢：正在下载无头浏览器，等它完成
- 生成的画面空白：检查 frame(t) 是否有绘制逻辑
- 中文乱码：给页面指定字体与 lang
- 导出体积过大：降低分辨率或码率再渲染
- Windows 上路径报错：把工程放在不含空格的目录

## 免责声明

本仓库为第三方指南，与 OpenFilm 官方无隶属关系，不代表官方立场。
教程基于官方文档编写（更新日期：2026-11-01），项目迭代快，请以[官方文档](https://github.com/openfilm/openfilm#readme)为准。
因使用本教程产生的部署问题，请先在官方仓库的 issue 中检索。
