<?php

$basePath = dirname(dirname(__DIR__));
$tmpPath = $basePath . '/tmp';
$pdfFile = $tmpPath . '/TNN.pdf';
$txtFile = $tmpPath . '/TNN.txt';
if (!file_exists($tmpPath)) {
    mkdir($tmpPath, 0777);
}
if (!file_exists($pdfFile)) {
    file_put_contents($pdfFile, file_get_contents('http://www.tnec.gov.tw/ezfiles/4/1004/attach/70/pta_19768_3344867_29199.pdf'));
}

$result = array();

/*
 * csv files were extracted by https://github.com/yllan/TextPositionExtractor
 */
foreach (glob('/home/kiang/public_html/TextPositionExtractor/out/*.csv') AS $csvFile) {
    $info = pathinfo($csvFile);
    $result[$info['filename']] = array();
    $fh = fopen($csvFile, 'r');
    while ($line = fgetcsv($fh, 2048)) {
        if (empty(trim($line[1])))
            continue;
        if ($line[1] > 77 && $line[2] > 99) {
            if (!isset($result[$info['filename']][$line[2]])) {
                $result[$info['filename']][$line[2]] = array();
            }
            $result[$info['filename']][$line[2]][$line[1]] = $line[0];
        }
    }
}

unset($result['0']);
unset($result['1']);
unset($result['2']);

foreach ($result AS $f => $s) {
    ksort($result[$f]);
    foreach ($result[$f] AS $j => $k) {
        $result[$f][$j][118] = $result[$f][$j][242] = $result[$f][$j][410] = $result[$f][$j][460] = "\t";
        ksort($result[$f][$j]);
        $result[$f][$j] = implode('', $result[$f][$j]);
        $result[$f][$j] = explode("\t", $result[$f][$j]);
    }
}

ksort($result);

$records = array();
$currentIndex = 0;
foreach ($result AS $p) {
    foreach ($p AS $line) {
        foreach ($line AS $k => $v) {
            $line[$k] = str_replace(array('帄'), array('平'), trim($v));
        }
        if (mb_strlen($line[2], 'utf-8') > 2 && (mb_substr($line[2], 2, 1, 'utf-8') === '區') || mb_substr($line[2], 1, 1, 'utf-8') === '區') {
            ++$currentIndex;
            $records[$currentIndex] = array(0 => '', 1 => '', 2 => '', 3 => '', 4 => '');
        }
        foreach ($line AS $k => $v) {
            if (isset($records[$currentIndex][$k])) {
                $records[$currentIndex][$k] .= $v;
            }
        }
    }
}

$oh = fopen($basePath . '/2014/booth/TNN.csv', 'w');
fputcsv($oh, array('編號', '場所名稱', '投(開)票所地址', '所屬里別', '所屬鄰別'));
foreach ($records AS $record) {
    fputcsv($oh, $record);
}
fclose($oh);
