# rules-and-scripts

多平台代理规则与脚本仓库，当前覆盖：
- Surge
- Clash
- Quantumult X
- Shadowrocket
- Stash

## 仓库结构

- `sources/`：规则单一来源（只维护这里）
- `scripts/sync_rules.sh`：从 `sources/` 生成各平台规则
- `surge/rule/`：Surge 规则
- `clash/`：Clash 规则（YAML provider 格式）
- `qx/`：Quantumult X 规则
- `shadowrocket/rule/`：Shadowrocket 规则
- `loon/rule/`：Loon 规则
- `scripts/stash/`：Stash 脚本与示例

## 规则订阅地址

### Bybit
- Surge: `https://raw.githubusercontent.com/Lxp1986/rules-and-scripts/refs/heads/master/surge/rule/bybit/bybit.list`
- Loon: `https://raw.githubusercontent.com/Lxp1986/rules-and-scripts/refs/heads/master/loon/rule/bybit/bybit.list`
- Clash: `https://raw.githubusercontent.com/Lxp1986/rules-and-scripts/refs/heads/master/clash/Bybit.yaml`
- Quantumult X: `https://raw.githubusercontent.com/Lxp1986/rules-and-scripts/refs/heads/master/qx/bybit.list`

### Gate
- Surge: `https://raw.githubusercontent.com/Lxp1986/rules-and-scripts/refs/heads/master/surge/rule/gate/gate.list`
- Loon: `https://raw.githubusercontent.com/Lxp1986/rules-and-scripts/refs/heads/master/loon/rule/gate/gate.list`
- Clash: `https://raw.githubusercontent.com/Lxp1986/rules-and-scripts/refs/heads/master/clash/gate.yaml`
- Quantumult X: `https://raw.githubusercontent.com/Lxp1986/rules-and-scripts/refs/heads/master/qx/gate.list`
- Shadowrocket: `https://raw.githubusercontent.com/Lxp1986/rules-and-scripts/refs/heads/master/shadowrocket/rule/gate/gate.list`

### Apple Arcade (Loon)
- Loon: `https://raw.githubusercontent.com/Lxp1986/rules-and-scripts/refs/heads/master/loon/rule/apple/apple_arcade.list`

## 维护方式（重要）

1. 只修改 `sources/bybit.rules`、`sources/gate.rules`、`sources/apple_arcade.rules`
2. 运行：

```bash
./scripts/sync_rules.sh
```

3. 提交生成后的平台文件

这个流程可以保证：
- 自动去重
- 各客户端内容一致
- Clash 文件统一为 `rules:` YAML 格式

## Stash 油价脚本

- 文件：`scripts/stash/youjia/oil.js`
- 示例配置：`scripts/stash/youjia/oil.stoverride`

脚本不再内置公开 API key，请在 `argument` 中传入：
- `provname=广东`
- `apikey=你的天行key`

也支持多个 key 轮询：
- `apikeys=key1,key2,key3`
