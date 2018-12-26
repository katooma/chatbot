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
   {'From', 'sheshbot@0xc9.net'},
   {'User-Agent', 'sheshbot'},
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

  local msg = message.content:upper()

  if (msg:match('TRANNY')) then
    message:addReaction('😡')
  end

  if (message.author.bot) then
    if (message.mentionedUsers[1]) then
      local id = message.mentionedUsers[1][1]
      if (id == client.user.id) then
        message:reply('<:owokitty:526914511840477195>')
      end
    end
    return
  end

  local bot_mentioned
  if (message.content:match('474661229483393057')) then
    bot_mentioned = true
  end

  if (bot_mentioned) then
    if (msg:match('HE[LW][LW]O')) then
      message:reply('Hewwo!~')
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

  if (message.content:match('^s!spam ')) then
    local s = message.content:sub(8)
    local r = s
    while (true) do
      local nr = r .. s
      if (#nr > 2000) then
        message:reply(r)
        return
      end
      r = nr
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

  if (message.content:match('^s!pat')) then
    if (message.mentionedUsers[1]) then
      local id = message.mentionedUsers[1][1]
      if (message.author.id == id) then
        message:reply{
          content = '<@' .. message.author.id .. '> is petting themselves!',
          file = 'img/pat/self' .. tostring(math.random(2)) .. '.gif',
        }
      elseif (id == client.user.id) then
        message:reply('<a:blobblush:526911657679781888>')
      else
        message:reply{
          content = '<@' .. message.author.id .. '> has given <@' .. id .. '> headpats!',
          file = 'img/pat/' .. tostring(math.random(7)) .. '.gif',
        }
      end
      return
    else
      message:reply('Who do you want to pat?')
      return
    end
  end

  if (message.content == 's!help') then
    local fp = io.open('./help.txt', 'r')
    if not (fp) then
      message:reply('Could not read `help.txt`')
      return
    end
    message:reply(fp:read('*a'))
    fp:close()
    return
  end

  if (message.content == 's@help') then
    local fp = io.open('./adminhelp.txt', 'r')
    if not (fp) then
      message:reply('Could not read `adminhelp.txt`')
      return
    end
    message:reply(fp:read('*a'))
    fp:close()
    return
  end

  if (message.content == 's.help') then
    local fp = io.open('./ownerhelp.txt', 'r')
    if not (fp) then
      message:reply('Could not read `ownerhelp.txt`')
      return
    end
    message:reply(fp:read('*a'))
    fp:close()
    return
  end

  if (message.content:match('^s@getcolor')) then
    if (message.mentionedUsers[1]) then
      local id = message.mentionedUsers[1][1]
      local c = message.guild:getMember(id):getColor()
      message:reply{
        embed = {
          description = c:toHex(),
          color = c.value,
        }
      }
      return
    else
      message:reply('Please mention a user.')
      return
    end
  end

  if (message.content:match('^s@joined')) then
    if (message.mentionedUsers[1]) then
      local id = message.mentionedUsers[1][1]
      local member = message.guild:getMember(id)
      local date
      local time
      do
        local joinedat = member.joinedAt
        date = joinedat:gsub('T.*$', '')
        time = joinedat:gsub('^.*T', ''):gsub('%..*$', '')
      end

      message:reply(member.user.tag .. ' joined on ' .. date .. ' at ' .. time)
      return
    else
      message:reply('Please mention a user.')
      return
    end
  end

  if (message.content:match('^=2') and (message.author.id == '394766718494441493')) then
    local f = "local client, message = ...\n"
    local s = loadstring(f .. message.content:sub(4))
    local r = s(client, message)
    if (r) then
      message:reply(tostring(r))
    end
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
