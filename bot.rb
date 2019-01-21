require 'telegram/bot'
require "mediawiki_api"

# TODO: Sostituire con token
Telegram.bots_config = {
  default: "INSERIRE_QUI_PROPRIO_TOKEN"
}
#TODO: Sostituire con base
chat_id = "@Vociwiki"
client = MediawikiApi::Client.new "http://it.wikipedia.org/w/api.php"
unless File.exist?('pagenumber.txt')
  File.write('pagenumber.txt', '1')
end
loop do  
  query = client.query meta: 'siteinfo', siprop: 'statistics'
  pagequery = query.data
  if pagequery["statistics"]["articles"].to_i > File.read('pagenumber.txt').to_i
    File.write('pagenumber.txt', pagequery["statistics"]["articles"])
    query = client.query rctype: 'new', list: 'recentchanges', rcprop: 'title|ids|sizes|flags|user'
    editquery = query.data
    Telegram.bot.send_message(chat_id: chat_id, text: "Nuova voce, si vola! Ora siamo a #{pagequery["statistics"]["articles"]} Creata da #{editquery["recentchanges"][0]["user"]} col titolo #{   puts editquery["recentchanges"][0]["title"]   }")
  end
end