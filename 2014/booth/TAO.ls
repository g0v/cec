require! <[fs sprintf]>
csv = require 'csv-parser'

res = []
end = ->
  console.log JSON.stringify res, null, 2

var town

data <- fs.createReadStream 'TAO.csv' .pipe csv! .on 'end' end .on 'data'
colmap = {
  編號: \id
  場所名稱: \place_name
  投開票所地址: \address
  所屬村里: \village
  所屬鄰別: \remark
}

data = {[colmap[k], v - /\s/g] for k, v of data when v}
if data.id is /\D/
  return if data.id is /^編號/
  [_, _town]? = data.id is /103年地方公職人員選舉投開票所設置地點一覽表（(.+)?）/
  town := _town
  return
data.seq = +data.id
data.id = sprintf "tao%04d" data.seq
data.town = town
#[_, data.village, data.remark]? = data.village.match /^(.*?里)(.*)$/
console.log \=== data unless data.village
data.address .= replace /[０１２３４５６７８９]/g ->
  (it.charCodeAt(0) - "０".charCodeAt(0)).toString!
console.log data unless data.address
data.county = 'TAO'
res.push data
