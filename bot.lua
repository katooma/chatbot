pcall(os.remove, 'discordia.log')
pcall(os.remove, 'gateway.json')
math.randomseed(os.time())
local discordia = require('discordia')
local client = discordia.Client()
local http = require('coro-http')
local json = require('json.json')

local trim = function(s)
  return s:match('^%s*(.-)%s*$')
end

local http_get = function(url)
  local head, body = http.request('GET', url, {
   {'User-Agent', 'sheshbot'}
  })
  return body
end

local stretch_table = function(t)
  local r = {}
  for i = 1, 11 do
    for k,v in pairs(t) do
      r[#r + 1] = v
    end
  end
  return r
end

catbot = {
  log_messages = false, -- print all messages to console
}

client:on('ready', function()
  print('Logged in as ' .. client.user.username)
  client:setGame('Neko Atsume')
end)

local parsemsg = function(message)
  if (catbot.log_messages) then
    print(message.channel.id, message.author.tag, message.content)
  end
  if (message.author.bot) then
    return
  end

  local bot_mentioned
  if (message.content:match('474661229483393057')) then
    bot_mentioned = true
  end

  local msg = message.content:upper()

  if (bot_mentioned) then
    if (msg:match('HE[LW][LW]O')) then
      message:reply('Hewwo!~')
      return
    end

    if (msg:match('HELP')) then
      local helptext = "**Help**\n\n"
      helptext = helptext .. "`/roll <die>`: Decently random random number generator. Examples: `/roll d6`, `/roll 2d4`\n"
      helptext = helptext .. "`geek joke`: Geek joke\n"
      helptext = helptext .. "`buzzwords`: Corporate ~~cancer~~ buzzwords\n"
      helptext = helptext .. "`be like bill`\n"
      helptext = helptext .. "`ron swanson`\n"
      helptext = helptext .. "`cat picture`\n"
      helptext = helptext .. "`random advice`\n"
      helptext = helptext .. "`product idea`\n"
      helptext = helptext .. "\n"
      helptext = helptext .. "Reaction images:\n"
      helptext = helptext .. "`s!excuseme`\n"
      helptext = helptext .. "`s!perv`\n"
      helptext = helptext .. "`s!several`\n"
      helptext = helptext .. "`s!uh`\n"
      helptext = helptext .. "\n"
      helptext = helptext .. "You can also ask me questions! Just be sure to mention me first.\n"
      if (message.author.id == '394766718494441493') then
        helptext = helptext .. "\n"
        helptext = helptext .. "========================================"
        helptext = helptext .. "Admin commands that only <@394766718494441493> can use:\n"
        helptext = helptext .. "`=0 <channel> <text>` Assume direct control\n"
        helptext = helptext .. "`=1 <text>` Assume direct control but faster\n"
        helptext = helptext .. "`=2 <lua>` Execute raw Lua code\n"
      end
      message:reply(helptext)
      return
    end

    if (msg:match('GEEK JOKE')) then
      message:reply(http_get('https://geek-jokes.sameerkumar.website/api'))
      return
    end

    if (msg:match('BUZZWORDS')) then
      local body = http_get('https://corporatebs-generator.sameerkumar.website')
      message:reply(json.decode(body).phrase)
      return
    end

    if (msg:match('BE LIKE BILL')) then
      local body = http_get('https://belikebill.ga/billgen-API.php?default=1')
      message:reply{file = {'belikebill.png', body}}
      return
    end

    if (msg:match('PRODUCT IDEA')) then
      local body = http_get('http://itsthisforthat.com/api.php?text')
      message:reply(body)
      return
    end

    if (msg:match('RON SWANSON')) then
      local body = http_get('http://ron-swanson-quotes.herokuapp.com/v2/quotes')
      message:reply(json.decode(body)[1])
      return
    end

    if (msg:match('CAT PICTURE')) then
      local body = http_get('https://api.thecatapi.com/v1/images/search')
      message:reply(json.decode(body)[1].url)
      return
    end

    if (msg:match('RANDOM ADVICE')) then
      local body = http_get('https://api.adviceslip.com/advice')
      message:reply(json.decode(body).slip.advice)
      return
    end

    do
      local question = trim(message.content:gsub('<.*>', '')):upper()
      if (question:match('%?$')) then
        if (question:match('^HOW MANY') or question:match('^HOW MUCH')) then
          -- amount
          local responses = stretch_table{
            '69,105.',
            '_num_.',
            '_num_.',
            '_num_.',
            'Hmm... _num_?',
            '_num_!',
            '_num_?',
            'At least _num_.',
            '_num_. (I think.)',
            'Probably _num_.',
          }
          local r = responses[math.random(#responses)]:gsub('_num_', tostring(math.random(100)))
          message:reply(r)
          return
        end

        -- boolean question
        local answers = stretch_table{
          'Yes.',
          'No.',
          'Maybe.',
          'Depends.',
          'Possibly.',
          'Heck no!',
          'Heck yeah!',
        }
        message:reply(answers[math.random(#answers)])
        return
      end
    end
  end

  if (message.content == 's!excuseme') then
    message:reply{file = 'img/excuseme.jpg'}
    return
  end
  if (message.content == 's!perv') then
    message:reply{file = 'img/perv.jpg'}
    return
  end
  if (message.content == 's!several') then
    message:reply{file = 'img/several.PNG'}
    return
  end
  if (message.content == 's!uh') then
    local reactions = stretch_table{
      'catgirl.jpg',
      'yaranaika.jpg',
      'loaf.png',
      'snowball.png',
    }
    message:reply{file = 'img/uh/' .. reactions[math.random(#reactions)]}
    return
  end

  if (message.content:match('^=2') and (message.author.id == '394766718494441493')) then
    local s = loadstring(message.content:sub(4))
    local r = tostring(s())
    message:reply(r)
    return
  end

  if (message.content:match('^=1') and (message.author.id == '394766718494441493')) then
    local s = message.content:sub(4)
    message:reply(s)
    message:delete()
    return
  end

  if (message.content:match('^=0') and (message.author.id == '394766718494441493')) then
    local s = message.content:sub(4)
    local cid = s:match('^([^ ]*) ')
    client:getChannel(cid):send(s:sub(#cid + 1))
    return
  end

  if (message.content:match('^/setwd') and (message.author.id == '394766718494441493')) then
    catbot._weighteddice = tonumber(message.content:match(' +(.*)$'))
    return
  end

  if (message.content:match('^/roll')) then
    local s = message.content:match(' +(.*)$')
    local n = s:match('^(.*)d')
    if (#n == 0) then
      n = 1
    else
      n = tonumber(n)
    end
    local m = tonumber(s:match('d(.*)$'))
    s = 0
    for i = 1, n do
      s = s + math.random(1, m)
    end
    --
    if (catbot._weighteddice) then
      if (catbot._weighteddice >= n) and (catbot._weighteddice <= (m * n)) then
        s = catbot._weighteddice
      end
      catbot._weighteddice = nil
    end
    --
    message:reply('<@' .. message.author.id .. '> rolled ' .. s)
    return
  end
end

client:on('messageCreate', function(message)
  local s, r = pcall(parsemsg, message)
  if not (s) then
    message:reply('ERROR: ' .. r)
  end
end)

do
  local token
  do
    local fp = io.open('./discordtoken.txt', 'rb')
    if not (fp) then
      print('Could not read token from `discordtoken.txt`')
      return
    end
    token = trim(fp:read('*a'))
    fp:close()
  end
  client:run('Bot ' .. token)
end
