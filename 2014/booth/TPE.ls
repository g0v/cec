require! <[fs sprintf]>
csv = require 'csv-parser'

res = []
end = ->
  console.log JSON.stringify res, null, 2

town = ''
data <- fs.createReadStream 'TPE.csv' .pipe csv! .on 'end' end .on 'data'
colmap = {
  投開票所編號: \id
  設置地點: \place_name
  詳細地址: \address
  所轄選舉人里鄰別: \village
  所轄原住民選舉人里鄰別: \indigenous_village
  電話號碼: \phone
  備註: \note
}
data = {[colmap[k], v - /\s/g] for k, v of data}
data.seq = +data.id
if not isNaN data.seq
  data.id = sprintf "tpe%04d" data.seq
  data.address .= replace /[０１２３４５６７８９]/g ->
    (it.charCodeAt(0) - "０".charCodeAt(0)).toString!
  data.county = 'TPE'
  data.town = town
  delete data.note
  res.push data
else
  town := data.id