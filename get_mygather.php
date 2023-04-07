<?php
$allList = [];
$params = [
    'page' => $argv[1] ?? 1,
    // 'sort' => 0, //依更新日排序
    'sort' => 1, //依加入日排序
];

$list = getList($params);
$params['page']++;
$allList = array_merge($allList, $list);
echo "sn_list.txt:\n\n";
foreach ($allList as $anime) {
    echo $anime['firstVideoId'] . " all #" . $anime['title'] . "\n";
}

// 取得我的動畫列表
function getList($params)
{
    echo "get list with params: " . json_encode($params) . " ...\n";
    $cookie = file_get_contents('cookie.txt');
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, "https://ani.gamer.com.tw/mygather.php?" . http_build_query($params));
    curl_setopt($ch, CURLOPT_COOKIE, $cookie);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    $output = curl_exec($ch);
    curl_close($ch);

    preg_match_all("/animeRef.php\?sn=(\d+)/", $output, $out, PREG_PATTERN_ORDER);
    $animeRefList = $out[1];
    preg_match_all("/\<p\ class\=\'theme\-name\'\>(.+)\<\/p\>/", $output, $out, PREG_PATTERN_ORDER);
    $animeTitleList = $out[1];

    $list = [];
    foreach ($animeRefList as $key => $value) {
        $list[$key]['refId'] = $value;
        $list[$key]['firstVideoId'] = getFirstVideo($value);
    }
    foreach ($animeTitleList as $key => $value) {
        $list[$key]['title'] = $value;
    }

    return $list;
}

// 取得我的動畫列表
function getFirstVideo($refId)
{
    $cookie = file_get_contents('cookie.txt');
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, "https://ani.gamer.com.tw/animeRef.php?sn=" . $refId);
    curl_setopt($ch, CURLOPT_COOKIE, $cookie);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_HEADER, true);
    $result = curl_exec($ch);
    $header = curl_getinfo($ch);

    preg_match_all("/animeVideo.php\?sn=(\d+)/", $header['redirect_url'], $out, PREG_PATTERN_ORDER);
    usleep(300);
    return $out[1][0];
}
