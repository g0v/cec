require! {
  fs
  async
}

result = {}

for item in require('../location/TPE.json')
  result[item.town] = {} unless result[item.town]?

  unless result[item.town][item.address]?
    result[item.town][item.address] = {[k, v] for k, v of item}
    result[item.town][item.address]['power'] = 0;
    result[item.town][item.address]['place_name'] = result[item.town][item.address]['place_name']
      .replace(/國小.+/g , '國小')
      .replace(/國中.+/g , '國中')
      .replace(/實小.+/g , '實小')
      .replace(/實中.+/g , '實中')
      .replace(/中心.+/g , '中心')

  reply = result[item.town][item.address]

  reply['power'] += 1;

for k, town of result
  reply = for address, poll of town
    poll

  fs.writeFileSync(
    './TPE/' + k + '.json',
    JSON.stringify(reply, null, 2)
  )