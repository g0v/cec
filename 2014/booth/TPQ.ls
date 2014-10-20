require! <[fs sprintf]>
csv = require 'csv-parser'

res = []
end = ->
  console.log JSON.stringify res, null, 2

data <- fs.createReadStream 'TPQ.csv' .pipe csv! .on 'end' end .on 'data'
colmap = {
  投開票所編號: \id
  場所名稱: \place_name
  投開票所地址: \address
  所屬里別: \village
  所屬鄰別: \remark
}

data = {[colmap[k], v - /\s/g] for k, v of data}
data.seq = +data.id
data.id = sprintf "tpq%04d" data.seq
data.address .= replace /[０１２３４５６７８９]/g ->
  (it.charCodeAt(0) - "０".charCodeAt(0)).toString!
data.county = 'TPQ'

if (data.seq <= 10)
  data.town = \石門區
else if (data.seq <= 28)
  data.town = \三芝區
else if (data.seq <= 119)
  data.town = \淡水區
else if (data.seq <= 137)
  data.town = \八里區
else if (data.seq <= 186)
  data.town = \林口區
else if (data.seq <= 232)
  data.town = \五股區
else if (data.seq <= 279)
  data.town = \泰山區
else if (data.seq <= 524)
  data.town = \新莊區
else if (data.seq <= 627)
  data.town = \蘆洲區
else if (data.seq <= 861)
  data.town = \三重區
else if (data.seq <= 1195)
  data.town = \板橋區
else if (data.seq <= 1439)
  data.town = \中和區
else if (data.seq <= 1577)
  data.town = \永和區
else if (data.seq <= 1688)
  data.town = \樹林區
else if (data.seq <= 1737)
  data.town = \鶯歌區
else if (data.seq <= 1879)
  data.town = \土城區
else if (data.seq <= 1947)
  data.town = \三峽區
else if (data.seq <= 2121)
  data.town = \新店區
else if (data.seq <= 2137)
  data.town = \深坑區
else if (data.seq <= 2150)
  data.town = \石碇區
else if (data.seq <= 2160)
  data.town = \坪林區
else if (data.seq <= 2166)
  data.town = \烏來區
else if (data.seq <= 2178)
  data.town = \平溪區
else if (data.seq <= 2224)
  data.town = \瑞芳區
else if (data.seq <= 2242)
  data.town = \雙溪區
else if (data.seq <= 2260)
  data.town = \貢寮區
else if (data.seq <= 2279)
  data.town = \金山區
else if (data.seq <= 2295)
  data.town = \萬里區
else if (data.seq <= 2406)
  data.town = \汐止區
else
  console.log 'Error Town'

res.push data