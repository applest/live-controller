express    = require 'express'
app        = express()
bodyParser = require 'body-parser'
ATEM       = require 'applest-atem'
config     = require './config.json'

switchers = []
for switcher in config.switchers
  atem = new ATEM
  atem.event.setMaxListeners(5)
  atem.connect(switcher.addr, switcher.port)
  switchers.push(atem)

app.use(bodyParser.json())
app.use('/', express.static(__dirname + '/public'))

app.get('/api/channels', (req, res) ->
  res.send(JSON.stringify(config.channels))
)

app.get('/api/switchersState', (req, res) ->
  res.send(JSON.stringify((atem.state for atem in switchers)))
)

app.get('/api/switchersStatePolling', (req, res) ->
  for atem in switchers
    atem.once('stateChanged', (err, state) ->
      res.end(JSON.stringify((atem.state for atem in switchers)))
    )
)

app.post('/api/changePreviewInput', (req, res) ->
  device = req.body.device
  input  = req.body.input
  switchers[device].changePreviewInput(input)
  res.send('success')
)

app.post('/api/changeProgramInput', (req, res) ->
  device = req.body.device
  input  = req.body.input
  switchers[device].changeProgramInput(input)
  res.send('success')
)

app.post('/api/autoTransition', (req, res) ->
  device = req.body.device
  switchers[device].autoTransition()
  res.send('success')
)

app.post('/api/cutTransition', (req, res) ->
  device = req.body.device
  switchers[device].cutTransition()
  res.send('success')
)

app.post('/api/changeTransitionPosition', (req, res) ->
  device   = req.body.device
  position = req.body.position
  switchers[device].changeTransitionPosition(position)
  res.send('success')
)

app.post('/api/changeTransitionType', (req, res) ->
  type = req.body.type
  for switcher in switchers
    switcher.changeTransitionType(type)
  res.send('success')
)

app.listen(8080)
