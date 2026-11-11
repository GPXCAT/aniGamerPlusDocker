<?php
// 從「我的動畫」收藏列表產生 sn_list.txt 內容
// 用法: php get_mygather.php [頁數]   (需要 cookie.txt)

$page = (int)($argv[1] ?? 1);
$cookie = trim(@file_get_contents(__DIR__ . '/cookie.txt'));
if ($cookie === '') {
    fwrite(STDERR, "cookie.txt 不存在或是空的\n");
    exit(1);
}

$list = getList($cookie, [
    'page' => $page,
    // 'sort' => 0, //依更新日排序
    'sort' => 1, //依加入日排序
]);

// 只有結果輸出到 stdout，可直接 >> sn_list.txt
foreach ($list as $anime) {
    if (!$anime['firstVideoId']) {
        fwrite(STDERR, "找不到第一集: {$anime['title']} (ref {$anime['refId']})\n");
        continue;
    }
    echo "{$anime['firstVideoId']} all <{$anime['year']} {$anime['title']}> #{$anime['title']}\n";
}

function request($url, $cookie, $followRedirectInfo = false)
{
    $ch = curl_init($url);
    curl_setopt_array($ch, [
        CURLOPT_COOKIE => $cookie,
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_USERAGENT => 'Mozilla/5.0',
        CURLOPT_TIMEOUT => 30,
    ]);
    $output = curl_exec($ch);
    $redirect = curl_getinfo($ch, CURLINFO_REDIRECT_URL);
    curl_close($ch);
    return $followRedirectInfo ? (string)$redirect : (string)$output;
}

// 取得我的動畫列表
function getList($cookie, $params)
{
    fwrite(STDERR, "get list with params: " . json_encode($params) . " ...\n");
    $output = request("https://ani.gamer.com.tw/mygather.php?" . http_build_query($params), $cookie);

    preg_match_all("/animeRef\.php\?sn=(\d+)/", $output, $refs);
    preg_match_all("/<p class='theme-name'>(.+?)<\/p>/", $output, $titles);
    preg_match_all("/<p class='theme-time'>(.+?)<\/p>/", $output, $years);

    $list = [];
    foreach ($refs[1] as $i => $refId) {
        $year = str_replace(["年份：", "/"], ["", "-"], $years[1][$i] ?? '');
        $list[] = [
            'refId' => $refId,
            'firstVideoId' => getFirstVideo($cookie, $refId),
            'title' => html_entity_decode($titles[1][$i] ?? '', ENT_QUOTES, 'UTF-8'),
            'year' => $year,
        ];
    }
    return $list;
}

// 取得動畫第一集的 sn
function getFirstVideo($cookie, $refId)
{
    $redirect = request("https://ani.gamer.com.tw/animeRef.php?sn=" . $refId, $cookie, true);
    usleep(300 * 1000); // 0.3 秒，避免請求太快
    return preg_match("/animeVideo\.php\?sn=(\d+)/", $redirect, $m) ? $m[1] : null;
}
