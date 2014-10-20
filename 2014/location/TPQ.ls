require! {
  fs
  https
  async
}

filename = 'TPQ'
list = require('./' + filename + '.json')

county =
  TPE: '台北市'
  TPQ: '新北市'

function getLocation (address, cb)
  https.get(
    'https://maps.googleapis.com/maps/api/geocode/json?address='+address+'&sensor=false'
    , (res) ->

      body = '';
      res.on 'data', (chunk) ->
        body += chunk

      res.on 'end' , ->

        try
          reply = JSON.parse(body)

          if ('ZERO_RESULTS' == reply.status)
            location =
              lat: 0
              lng: 0
          else
            location = reply.results[0].geometry.location

          setTimeout(
            -> cb(null, location)
            , 500
          )

        catch

          setTimeout(
            -> getLocation(address, cb)
            , 3000
          )
  )

async.mapSeries(
  list
  , (item, cb) ->
    console.log '>', item.place_name, item.address

    if (item.location)
      cb(null, item)
    else
      address = county[item.county] + item.town + item.address
      getLocation address, (err, location) ->
        item.location = location

        fs.writeFileSync './' + filename + '.json', JSON.stringify(list, null, 2)

        cb(null, item)

  , (err, result) ->
    console.log 'Completed'
)