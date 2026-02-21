const params = getParams(typeof $argument === "string" ? $argument : "");
const provinceName = params.provname || "江苏";
const apiKeys = getApiKeys(params);

if (apiKeys.length === 0) {
  $done({
    title: "今日油价",
    content: "缺少 apikey。请在 argument 中添加 apikey=你的天行 key",
    icon: params.icon,
    "icon-color": params["icon-color"] || params.color
  });
}

const apiUrls = apiKeys.map(
  (key) =>
    `https://apis.tianapi.com/oilprice/index?key=${encodeURIComponent(key)}&prov=${encodeURIComponent(provinceName)}`
);

let currentIndex = 0;

function testNextUrl() {
  if (currentIndex >= apiUrls.length) {
    $done({
      title: "今日油价",
      content: `请求失败：${provinceName} 油价暂时不可用（请检查 apikey 是否有效）`,
      icon: params.icon,
      "icon-color": params["icon-color"] || params.color
    });
    return;
  }

  const apiUrl = apiUrls[currentIndex];

  $httpClient.get(apiUrl, (error, response, data) => {
    if (error || !data) {
      currentIndex++;
      testNextUrl();
      return;
    }

    handleResponse(data);
  });
}

function handleResponse(data) {
  let oilPriceData;
  try {
    oilPriceData = JSON.parse(data);
  } catch (e) {
    currentIndex++;
    testNextUrl();
    return;
  }

  if (oilPriceData.code === 200 && oilPriceData.result) {
    const oilPriceInfo = oilPriceData.result;
    const message = `地区：${oilPriceInfo.prov}\n0号柴油：${oilPriceInfo.p0}元/升\n89号汽油：${oilPriceInfo.p89}元/升\n92号汽油：${oilPriceInfo.p92}元/升\n95号汽油：${oilPriceInfo.p95}元/升\n98号汽油：${oilPriceInfo.p98}元/升\n更新时间：${oilPriceInfo.time}`;

    $done({
      title: "今日油价",
      content: message,
      icon: params.icon,
      "icon-color": params["icon-color"] || params.color
    });
    return;
  }

  currentIndex++;
  testNextUrl();
}

function getApiKeys(input) {
  if (input.apikeys) {
    return input.apikeys
      .split(",")
      .map((item) => item.trim())
      .filter(Boolean);
  }

  if (input.apikey) {
    return [input.apikey.trim()].filter(Boolean);
  }

  return [];
}

function getParams(param) {
  if (!param) return {};

  return Object.fromEntries(
    param
      .split("&")
      .filter(Boolean)
      .map((item) => {
        const [rawKey, ...rawValue] = item.split("=");
        const key = safeDecode(rawKey || "");
        const value = safeDecode(rawValue.join("="));
        return [key, value];
      })
      .filter(([key]) => key)
  );
}

function safeDecode(value) {
  try {
    return decodeURIComponent(value || "");
  } catch (e) {
    return value || "";
  }
}

testNextUrl();
