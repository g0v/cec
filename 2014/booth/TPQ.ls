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
res.push data