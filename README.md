yamdc-script
===

yamdc 的远程脚本/规则集仓库，主要包含：

- ruleset 规则集
- ruleset 测试用例
- 相关测试脚本与 GitHub Actions

当前仓库内置了规则集回归测试：

- PR 合入 `master` 时会自动执行 `.github/workflows/ruleset-test.yml`
- 也支持手动触发 `workflow_dispatch`
- 手动触发时可指定 `yamdc_ref`，例如：`latest`、`master`、`v1.0.0`

本地也可以直接运行：

```bash
bash ./scripts/run_ruleset_test.sh
```

等价的底层命令是：

```bash
yamdc ruleset-test --ruleset=./ --casefile=./cases --output=json
```

其中：

- `ruleset` 指向 bundle 根目录，根目录下的 `manifest.yaml` 用于指定规则入口
- `casefile` 可以是单个 JSON 文件，也可以是一个目录
- 当 `casefile` 是目录时，会扫描目录下全部 `*.json` 文件并合并执行

如需指定 yamdc 二进制路径：

```bash
YAMDC_BIN=/path/to/yamdc bash ./scripts/run_ruleset_test.sh
```

**NOTE: 由于是解释执行 golang，能做的事情很多，所以应尽量避免使用第三方脚本；如果一定要使用，建议在 docker 中执行。**
