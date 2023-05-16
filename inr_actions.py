from jaseci.jsorc.live_actions import jaseci_action
import re
import dateparser
from datetime import date
from dateutil.relativedelta import relativedelta

@jaseci_action(act_group=["inr"], allow_remote=True)
def remove_html_tags(text: str):

    #remove funny chars that may be there
    ansi_escape = re.compile(r'(\x9B|\x1B\[)[0-?]*[ -\/]*[@-~]')
    text = ansi_escape.sub('', text)
    text = re.sub(r"&.*?;", '', text)
    text = text.replace('\\n','')
    #remove html tags
    tags = re.compile('<.*?>')
    return tags.sub('', text)


@jaseci_action(act_group=["inr"], allow_remote=True)
def phrase_to_date(phrase: str):
    _date = dateparser.parse(phrase)
    if(_date):
        return _date.strftime("%Y-%m-%d")
    else: return (date.today()).strftime("%Y-%m-%d")
