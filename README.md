# rules-and-scripts

多平台代理规则与脚本仓库，当前覆盖：
- Surge
- Clash
- Quantumult X
- Shadowrocket
- Stash
- Loon

## 仓库结构

- `sources/`：规则单一来源（只维护这里）
- `scripts/sync_rules.sh`：从 `sources/` 生成各平台规则
- `surge/`：Surge 规则
- `clash/`：Clash 规则（YAML provider 格式）
- `qx/`：Quantumult X 规则
- `shadowrocket/`：Shadowrocket 规则
- `loon/`：Loon 规则
- `scripts/stash/`：Stash 脚本与示例

各平台规则按“每条规则一个子目录”组织：
- `surge/`
- `clash/`
- `qx/`
- `shadowrocket/`
- `loon/`

每条规则目录内均包含：
- 规则文件（`.list` 或 `.yaml`）
- `README.md`（该规则订阅链接）

## 维护方式（重要）

1. 只修改 `sources/*.rules`（例如 `sources/bybit.rules`、`sources/gate.rules`、`sources/bitmart.rules`、`sources/ovital.rules`、`sources/metamask.rules`）
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

## MetaMask 钱包及卡片

Loon 订阅地址：
https://raw.githubusercontent.com/Lxp1986/rules-and-scripts/refs/heads/master/loon/metamask/metamask.list

在 Loon 的 [Remote Rule] 中使用该 URL，并选择你自己的代理策略组。规则文件只包含两段式域名规则，不内置策略名称。请将此规则置于可能抢先匹配的 DIRECT/FINAL 规则之前。

覆盖 MetaMask 官方域、Infura、Card 网页入口、Crypto Life 管理页、支持的链及常见第三方 RPC 域名。自定义 RPC、内置浏览器访问的任意 dApp、随时变化的 KYC 服务需按 Loon 请求记录补充。代理不会改变 MetaMask Card 的地区资格，也不负责实体卡/Apple Pay 的支付网络。Card 网站请从 MetaMask App 或 Portfolio 官方入口进入，不要仅凭本规则认定某链接安全。

参考：https://support.metamask.io/trade/metamask-card/getting-started-with-card/ 、https://support.metamask.io/trade/metamask-card/managing/ 、https://nsloon.app/docs/Rule/sub_rule/
