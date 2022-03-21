+++
title = "ニター (Nitā) - A Discord Bot and Command Line Program for Language Study"
date = Date(2022, 03, 21)
hascode = false
rss = "nitaa"
tags = ["personal"]
hasmath = true
mintoclevel=2
maxtoclevel=2
descr = """
@@row
@@container
~~~
<img class="left" style="width:40%;" src="/assets/fujisan.jpg">
~~~
This blog post describes a personal project in which I created a command line program in Python to help me practice Japanese "on the side" while I work. Features include: standard flashcard-style vocab study, japanese text-to-speech for pronunciation, webscraping for "words of the day" and a companion Discord bot! While the program is geared towards my study of Japanese language, it can easily be modified to suit any language with a few tweaks. Image: Fuji-san Station Hotel, Mt. Fuji (富士山) in background.
@@
@@

"""
+++

# {{title}}
@@row
@@container
~~~
<img class="left" style="width:40%;" src="/assets/fujisan.jpg">
~~~
This blog post describes a personal project in which I created a command line program in Python to help me practice Japanese "on the side" while I work. Features include: standard flashcard-style vocab study, japanese text-to-speech for pronunciation, webscraping for "words of the day" and a companion Discord bot! While the program is geared towards my study of Japanese language, it can easily be modified to suit any language with a few tweaks. Image: Fuji-san Station Hotel, Mt. Fuji (富士山) in background.
@@
@@

## Motivation
I like to call myself a "hobby world traveler." I pick up hobbies at a whim - woodworking, RC car design, game console modding, even reading - and after a few months of having a lot of fun with them, I drop them, and leave them to be picked up again in a few months time.

Of course, when I started studying Japanese, my friends and family figured it would be no different. This time, however, I was determined to make it last. I bought textbooks, writing workbooks, introductory storybooks, and even signed up for a class at the [Japan Society](https://www.japansociety.org), all while climbing up to the diamond league in Duolingo. I've been going strong for about 9 months now, and although my progress is slow, I study every day.

Japanese is an incredibly difficult language for Western speakers to learn, due to its unique and complex grammar and intimidating writing system. It has two "alphabets," hiragana (ひらがな) for native Japanese words, katakana (カタカナ) for loan words from languages other than Chinese, and kanji (漢字) which are Chinese characters. Hiragana and katakana are smaller character sets, where each character represents a syllable and is almost always pronounced phonetically in the exact same way. This is nice, better than English even!

On the other hand, each Kanji character represents a concept rather than a word, and can have many possible pronunciations depending on context. For example, 三 is the Kanji for the number 3. It can be pronounced "san" like in 三時 (sanji, 3 o'clock) or as mi like in 三日　(mikka, third day of the month). There are over 2000 kanji characters in use in Japan today, and learning to read them is a challenging and slow process. The only solution is to practice every single day.

There are lots of apps designed to teach you Japanese, including Duolingo which I largely like although it has its issues. The browser version is also perfectly fine, but during work I try to avoid both my phone and my web browser. I basically keep three windows open: a terminal, Matlab, and Discord.

Ok sure, Discord seems worse for productivity than my phone or web browser, but I use it to listen to music or Youtube videos with some friends of mine while I work. The server has four people, a bot I made last year that streams Youtube videos named Tongy, and now a new bot for Japanese language study which I'll describe below. Either in a terminal tab or in Discord, I can learn new words or practice ones I ought to know continuously as the day goes on, all without opening a browser or getting sucked in to the smartphone black hole.

## ニター　(Nitā) - Modes of operation in terminal
My program is called ニター, pronounced "Nitaa," short for 日本語のターミナル, "nihongo no taaminaru," translating to Japanese language terminal. It is a Python script with three basic "modes" - (1) a Continuous Mode that operates like never-ending flashcards, drawing from a long list of words, (2) an Edit Mode that allows users to add more words, edit old words and delete words from the working list, and (3) Word of the Day, which prints a new word for you scraped from the internet.

For continuous and edit modes, each word is stored as a Python dictionary, containing fields "Term" which contains the word in full Kanji/Hiragana/Katakana combination, "Pronunciation" which contains hiragana for the pronunciation of the word (every kanji's pronunciation can be written in hiragana/katakana), "Meaning" which contains the English-language meaning, and "Tags" which is a list of strings sorting the word. For example, "Tags" will likely contain the part of speech or the context of the word. For example, 三日 for third day of the month is a noun relating to time and date, and appears in chapter 4 of the Genki textbook, so it would have tags $\texttt{["noun", "time", "date", "chapter 4"]}$.

The vocab words are stored in a JSON file, which is read at startup and written into whenever a term is added, edited or removed. Importantly, the json read and write commands inherently deal only with ASCII characters. Kanji, hiragana and katakana are unicode characters, so the following modifications must be made: for reading and writing, the file open function must be passed an argument specifying the encoding
$$\texttt{with open(jsonfilename, 'w', encoding = 'utf8') as jsonfile}$$
(of course passing 'r' instead of 'w' if you want to read rather than write) and for writing only, the $\texttt{json.dump}$ function must be passed an argument telling it not to restrict itself to ascii characters:
$$\texttt{json.dump(vocablist, json\_file, indent = 4, ensure\_ascii = False)}$$
I like to use the indent argument, because it makes the JSON file easier to read in plain text. You can open it and see each entry listed in a really visually readable way, making it much easier to manually edit terms that way if you'd rather for some reason.

Continuous mode has several variations - you can go practice words from a big pile of all of the words in the JSON file, or you can practice by tag. Say my homework was to study all of the words relating to date, or all of the words from chapter 5 of the Genki textbook - we include tags so that this is possible with ニター.


In any continuous mode subcase, the term appears, and you press enter after considering the term to see the meaning. You can choose to have the first output (front side of the flashcard) show only the kanji/hiragana/katakana standard composition of the word, or to show both this and the pronunciation. In the former case, the pronunciation will appear with the meaning after enter is pressed. This is better for practicing kanji. In the latter case, only the meaning will appear "on the other side of the flashcard." This is better for practicing listening comprehension and speaking vocab.

You can also practice from a massive file titled Old Words of the Day, which I have generated by scraping [an online Word of the Day widget](https://wotd.transparent.com/widget/?lang=japanese) (written in Javascript) for every day in the past year. The process of generating this file is described in the webscraping section below. Practicing from this file gives a broad range of brand new words that would not be likely to appear in my other study material, which switches things up nicely if I don't feel up to practicing my own input words anymore.

Word of the Day Mode scrapes this same same widget at runtime to find today's Word of the Day, and outputs it on the screen. This is distinct from the old words of the day, which are generated prior to runtime by a big scraping script.

At any time the user can choose to turn sound on. This uses the Google Translate API to generate an mp3 file via text-to-speech on the pronunciation field when it is displayed, and plays it through the speakers (either after enter is pressed if the user is practicing kanji, or on "front side of the card" otherwise). Of course, this file is saved locally and overwritten every time a word appears so that only a small amount of data is taken up by audio files.

To see it in action, watch the video below!

~~~
<iframe style="width:100%;"
src="https://youtu.be/iVxNtRFjaHY">
</iframe> 
~~~

## Bot commands

The companion Discord bot has almost all of this functionality, save Edit Mode. Instead, it reads in the JSON file every time a command is called so that if a change is made through the terminal program while it is online, it is still reflected by the bot. This does not noticeably increase runtime. Commands begin with $\texttt{=}$, and are as follows:

$\texttt{=wotd}$ - scrapes for, and then prints, the word of the day, exactly as in the terminal.
$\texttt{=wk}$ - Prints a term from the user-input JSON file without pronunciation, waits for a message, then responds with the pronunciation and meaning.
$\texttt{=wh}$ - Prints a term from the user-input JSON file with pronunciation, waits for a message, then responds with the pronunciation and meaning.
$\texttt{=owotdk}$ - Prints a term from the scraped Old Word of the Day JSON file without pronunciation, waits for a message, then responds with the pronunciation and meaning.
$\texttt{=owotdh}$ - Prints a term from the Old Word of the Day JSON file with pronunciation, waits for a message, then responds with the pronunciation and meaning.
$\texttt{=join}$ - Joins the voice channel that the message author is in, if they are in one.
$\texttt{=leaves}$ - Leaves the voice channel if it is in one.

In these commands, the "k" stands for kanji and the "h" stands for hiragana. The bot works just as in the terminal whether it is in voice chat or not. Instead of sound being something that can be turned on and off, the bot instead checks if it is in a voice channel. If it is, it plays the pronunciation into the voice channel. The implementation of this is described below.

The bot, named ビングスバット by default (bingusubatto, or bingus bot), has dons the visage of Furio from The Sopranos. This is a silly gag that started with my original Youtube bot, Tongy, whose profile picture is Bobby Bacala from The Sopranos... I don't entirely know why, but I find this unreasonably funny!

~~~
<iframe style="width:100%;"
src="https://youtu.be/Rr51eZ8JTpI">
</iframe> 
~~~

## The imprecise art of webscraping

My experience with webscraping prior to this project was pretty minimal. I had worked on a silly little project last year when my partner and I were playing through Pokemon Red and Blue version. The program, called DexTerm, served as a command-line information hub for the game, allowing you to print stats of Pokemon, the moves they could learn at which levels or by TM, the locations you could find them in each version of the game, and much more. It also included information about TMs and HMs. The program also operates by reading from giant JSON files containing all of this information, generated by webscraping from [Serebii](serebii.net). As there is a lot of information to sift through, it was much faster to webscrape than to manually create this database.

Serebii is an awesome website which presents information from all of the Pokemon series games in a very succinct way, which is a nice feature when compared to the unnecessarily bloated gaming websites that seem to populate the front page of Google searches. Dexterm presents the same information streamlined to the command line, much faster than scrolling around web pages and with many more search capabilities. It was a nice, fun little project which I've not used much since, but will come in handy on my future playthroughs.

I bring it up because it taught me a few very important things about webscraping - namely that it is extremely reliant upon the consistency of whomever wrote the web pages in the first place. Is the div containing the Pokemon's capture rate always given the same class name across pages? Are the page URLs consistently named in the same format? In the case of Serebii, this was probably several non-professionals... decades ago. The consistency was low, so I had to account for several edge-cases.

*BeautifulSoup* is the library I used to parse the HTML code in my DexTerm project, and it is in fact quite *beautiful*. It lets you search sites for divs by many parameters, and in my case, class name was plenty. Basically, I would analyze the HTML in my browser's developer mode, find the divs containing the information I was interested, grab the information and store it in my JSON file.

Ok, enough about my facile Pokemon project -- enter the [Word of the Day widget](https://wotd.transparent.com/widget/?lang=japanese), which is a really nice little widget that gives a Japanese word, its Yomigana reading (that is, the hiragana for its pronunciation), its English meaning and its part of speech. These are precisely the four fields in my dictionary entry for each term! It also reads it out for you, gives example sentences and so on, which I do not use in my program. The sound can still be handled by the Google Translate API.

Looking at the HTML in developer mode, there is Japanese text inside spans with consistent class names on every word of the day. Silly me, I figured I could do the same thing as last time and just scrape the words directly by class name. This is what the line looks like when I open developer mode:

*<span class="js-label-part\_of\_speech wotdr-header">連絡先</span>*

Ok great, just find the text encased in the object with that class name and we're done. What would you know, the field is always empty! Now I am a low-level guy, hilariously unfamiliar with web development, which is part of why I take on these projects. My first thought is not "this is literally labeled js," but instead - "maybe BeautifulSoup is confused by the chinese characters." That was a time-sink, and a useless one. Luckily for us, BeautifulSoup has no trouble whatsoever with unicode characters.

It didn't take me *that* long to figure out that of course this was a dynamic feld. I mean, I could move around on a calendar in the widget without changing the URL. This seems obvious in retrospect, but so does everything, no? Requesting the source HTML alone will not suffice, but simply starting up the page in a browser populates the fields. The solution: use $\texttt{selenium}$, which opens a browser that can be navigated programatically!

With selenium, you create a webdriver using your favorite browser - in my case, I'm using Firefox. Given a URL, it will open a window, and you can then observe the webdriver's $\texttt{page\_source}$ field at any time to get HTML parseable by BeautifulSoup! In my case, if I just load up the browser and then grab the source immediately after, the fields will be populated with today's words.

$\texttt{from bs4 import BeautifulSoup}$\\
$\texttt{from selenium import webdriver}$
$\texttt{URL = "https://wotd.transparent.com/widget/?lang=japanese"}$
$\texttt{browser = webdriver.Firefox()}$\\
$\texttt{browser.get(URL)}$\\
$\texttt{soup = BeautifulSoup(browser.page\_source,"html.parser")}$
$\texttt{wotd = soup.find("span", \{"class": "js-wotd-wordsound-plus"\})}$

This is fine, but the browser selenium opens pops up as an actual window on my desktop. This is annoying and distracting. It was a bit tough to find a solution to this, as many StackOverflow answers suggest the depracated PhantomJS (I spent a while failing to get this working). Instead, I found a nice workaround with $\texttt{pyvirtualdesktop}$, which creates a virtual display in which the window pops up. The virtual display can be any size, so if you set its size to 0, it is perfectly invisible! Before I create my webdriver (as above), I start my display:

$\texttt{from pyvirtualdisplay import Display}$\\
$\texttt{display = Display(visible=0, size=(800,600))}$\\
$\texttt{display.start()}$

Beautiful. When I'm done, I do a $\texttt{browser.quit()}$ and $\texttt{display.stop()}$ to stop the virtual display and Firefox instances.

Next up - I have that giant list of old words of the day. How did I generate that? Well, using selenium in this same way, I can click the button on the widget that moves me to the previous day, then execute my BeautifulSoup scraping again, and add each day's word to the vocabulary list! I just have to find the button I need to click, then $\texttt{.click()}$ it!

$\texttt{from selenium.webdriver.common.by import By}$\\
$\texttt{browser.find\_element(by=By.CLASS\_NAME, value="prev.js-date-prev").click()}$

I did this in a long for loop, constantly clicking the back button and scraping for a new word, but hit a strange roadblock - on some days, I was getting an error that this button was covered by the calendar object. Now when I go to the site in my browser, I am never blocked by this object, so I don't really know what is causing the bug on these days. There is, however, a simple fix - if I know the name of the element blocking my button, I can execute a script to hide that element.

$\texttt{element = browser.find\_element(by=By.CLASS\_NAME,value="wotdr-calendar.js-calendar")}$
$\texttt{browser.execute\_script("arguments[0].style.visibility='hidden'", element)}$

Nice and easy. And that's it for the webscraping portion of my program!

## Sound via Google Translate

This is shockingly easy - while I am not actually translating anything, the Google translate python package has phenomenal text-to-speech. This is particularly nice for Japanese, as hiragana is totally phonetic. I have not heard a mispronunciation yet! Here is the code that does this:

$\texttt{from playsound import playsound}$\\
$\texttt{import gtts}$\\
$\texttt{tts = gtts.gTTS(entry["Pronunciation"],lang='ja')}$\\
$\texttt{tts.save("temp.mp3")}$\\
$\texttt{playsound("temp.mp3")}$

It is important to specify the language for $\texttt{gTTS}$. Hilariously, the default English voice will happily try to read the hiragana characters, correctly pronouncing the words in the most miserable accent possible!

## The Discord bot 

Lastly, the Discord bot companion was a quick modification from the command line program. Every option in the command line programs was simply turned into a bot command, using $\texttt{bot.command}$ and asynchronous functions. There is nothing too special about the Discord bot, although I somehow feel powerful to be opening shadow browsers and executing javascript with Discord commands. The sound works via first checking if the bot is in the voice channel, then creating the mp3 file exactly as above, and finally using Discord's $\texttt{play}$. While there are several options for how to use this function, I find the easiest is to use FFmpeg. Using your user path to FFmpeg, you can just do the following:

$\texttt{server = ctx.message.guild}$\\
$\texttt{voice\_channel = server.voice\_client}$\\
$\texttt{voice\_channel.play(discord.FFmpegPCMAudio(executable="/usr/bin/ffmpeg",source="temp.mp3"))}$

And that's that! This is how my language-learning program functions. Let me know if you have any questions at b.frost@columbia.edu, and have a great day!
