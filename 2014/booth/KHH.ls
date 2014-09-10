require! <[fs sprintf]>
csv = require 'csv-parser'

res = []
end = ->
  console.log JSON.stringify res

data <- fs.createReadStream 'KHH.csv' .pipe csv! .on 'end' end .on 'data'
colmap = {
  編號: \id
  設置地點: \place_name
  詳細地址: \address
  所轄里鄰別: \village
  電話: \phone
  原住民: \indigenous_remark
}

data = {[colmap[k], v - /\s/g] for k, v of data when v}
return unless data.place_name
data.seq = +data.id
data.id = sprintf "KHH-%04d" data.seq
[_, data.village, data.remark]? = data.village.match /^(.*?里)(.*)$/
console.log \=== data unless data.village
data.address .= replace /[０１２３４５６７８９]/g ->
  (it.charCodeAt(0) - "０".charCodeAt(0)).toString!
console.log data unless data.address
data.county = 'KHH'
res.push data
