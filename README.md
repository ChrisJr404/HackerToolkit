work in progress, star and follow to track progress

![DALL·E 2024-04-20 23 27 00 - Create a digital banner for the GitHub repository named 'HackerToolkit', ensuring it mirrors the previous design closely with only one change correct](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/170bf9c2-03c0-40ef-a9e9-230c76f65122)

# Welcome to the HackerToolkit 🛠️

**Your comprehensive suite for penetration testing, red teaming, and bug bounty hunting.**

HackerToolkit offers a curated selection of tools designed to enhance your hacking capabilities. This repository not only organizes these tools but provides information about them. Easily install all of them with one script. 

## Features:
- **Complete Tool Listings:** Access a meticulously organized list of tools included in the `install.sh` file, each with a detailed description to help you understand and choose the right tool for the right job.
- **Quick Installation:** Get up and running quickly with our `install.sh` script that allows you to download and install all tools at once (unless noted) — streamlining your setup process and saving you valuable time.
- **Cross-Distribution Compatibility:** Originally tailored for Kali Linux, our toolkit is compatible with many other Linux distributions, ensuring flexibility regardless of your preferred environment.

## Installation Instructions:
1. **Clone the Repository:** `git clone https://github.com/ChrisJr404/HackerToolkit.git`
2. **Navigate to the Repository:** `cd HackerToolkit`
3. **Run the Installation Script:** `./install.sh`

Embrace the power of a comprehensive hacking suite with HackerToolkit. Star the repo and follow me to stay updated with the latest tools and improvements!

# Table of Contents
- [Enumeration & Recon Tools](#enumeration--recon-tools)
  * [Ad & Analytic Trackers](#ad--analytic-trackers)
    + [relations.sh](#relationssh)
  * [Apex Domain Enumeration](#apex-domain-enumeration)
    + [check_mdi](#check_mdi)
    + [CloudRecon](#cloudrecon)
    + [FavFreak](#favfreak)
  * [Archival Enumeration](#archival-enumeration)
    + [gau](#gau)
    + [WayMore](#waymore)
  * [Change Detection](#change-detection)
    + [changedetection.io](#changedetectionio)
  * [Credential Collection Tools (emails, usernames, passwords, etc)](#credential-collection-tools-emails-usernames-passwords-etc)
    + [deepdarkCTI](#deepdarkcti)
    + [h8mail](#h8mail)
    + [hacxx-underground](#hacxx-underground)
    + [linkedin2username](#linkedin2username)
    + [WeakestLink](#weakestlink)
  * [Custom Wordlists](#custom-wordlists)
    + [CeWL](#cewl)
    + [wordlistgen](#wordlistgen)
  * [Directory Enumeration](#directory-enumeration)
    + [Dirsearch](#dirsearch)
    + [Feroxbuster](#feroxbuster)
    + [ffuf](#ffuf)
    + [Gobuster](#gobuster)
    + [Wfuzz](#wfuzz)
  * [Github Enumeration](#github-enumeration)
    + [github-search](#github-search)
    + [GitLeaks](#gitleaks)
  * [JavaScript](#javascript)
    + [jsluice](#jsluice)
    + [Linkfinder](#linkfinder)
  * [Mobile App Enumeration](#mobile-app-enumeration)
    + [APKLeaks](#apkleaks)
  * [Port Scanners (Active)](#port-scanners-active)
    + [AutoRecon](#autorecon)
    + [MASSCAN](#masscan)
    + [Naabu](#naabu)
    + [Nmap](#nmap)
    + [RustScan](#rustscan)
  * [Port Scanners (Passive)](#port-scanners-passive)
    + [Smap](#smap)
  * [Recon Frameworks](#recon-frameworks)
    + [reconFTW](#reconftw)
    + [Recon-ng](#recon-ng)
    + [reNgine](#rengine)
  * [Shodan Tools](#shodan-tools)
    + [karma v2](#karma-v2)
    + [shosubgo](#shosubgo)
    + [Smap](#smap-1)
    + [wtfis](#wtfis)
  * [Screenshotting](#screenshotting)
    + [Aquatone](#aquatone)
    + [Eyeballer](#eyeballer)
    + [EyeWitness](#eyewitness)
    + [go-stare](#go-stare)
    + [httpscreenshot](#httpscreenshot)
    + [httpx](#httpx)
  * [Spiders](#spiders)
    + [GoSpider is a fast web spider written in Go](#gospider-is-a-fast-web-spider-written-in-go)
  * [katana](#katana)
    + [hakrawler](#hakrawler)
  * [Subdomain Enumeration and Brute Force](#subdomain-enumeration-and-brute-force)
    + [Altdns](#altdns)
    + [AlterX](#alterx)
    + [Amass](#amass)
    + [assetfinder](#assetfinder)
    + [BBOT](#bbot)
    + [CloudRecon](#cloudrecon-1)
    + [dnsgen](#dnsgen)
    + [FavFreak](#favfreak-1)
    + [Findomain](#findomain)
    + [github-subdomains](#github-subdomains)
    + [Gotator](#gotator)
    + [puredns](#puredns)
  * [REGULATOR](#regulator)
    + [Shuffledns](#shuffledns)
    + [shosubgo](#shosubgo-1)
    + [Subfinder](#subfinder)
    + [Sublist3r](#sublist3r)
  * [Web Technology Enumeration](#web-technology-enumeration)
    + [webanalyze](#webanalyze)
    + [WhatWeb](#whatweb)
- [Exploitation](#exploitation)
  * [Active Directory](#active-directory)
    + [Bloodhound](#bloodhound)
    + [Empire](#empire)
    + [Powersploit](#powersploit)
  * [Linux Privilege Escalation](#linux-privilege-escalation)
    + [LinEnum](#linenum)
    + [LinPEAS](#linpeas)
    + [linuxprivcheck](#linuxprivcheck)
    + [Linuxprivchecker.py](#linuxprivcheckerpy)
  * [Password Spraying, Stuffing, Brute Forcing, Cracking, etc](#password-spraying-stuffing-brute-forcing-cracking-etc)
    + [CredMaster](#credmaster)
    + [Hashchat](#hashchat)
    + [Hydra](#hydra)
    + [John the Ripper](#john-the-ripper)
    + [Medusa](#medusa)
    + [WhereToGo](#wheretogo)
  * [Payload Lists](#payload-lists)
    + [Payloads All The Things](#payloads-all-the-things)
    + [SecLists](#seclists)
  * [Windows Privilege Escalation](#windows-privilege-escalation)
    + [WES-NG](#wes-ng)
    + [winPEAS](#winpeas)
  * [SQL Injection](#sql-injection)
    + [Ghauri](#ghauri)
    + [HBSQLI](#hbsqli)
    + [sqlmap](#sqlmap)
  * [Vulnerability Scanners](#vulnerability-scanners)
    + [Jaeles](#jaeles)
    + [Nuclei](#nuclei)
    + [Retire.js](#retirejs)
- [Red Teaming](#red-teaming)
  * [C2](#c2)
    + [NimPlant](#nimplant)
    + [SharpC2](#sharpc2)
  * [Distribution](#distribution)
    + [Axiom](#axiom)
    + [Fleex](#fleex)
    + [ShadowClone](#shadowclone)
  * [Phishing/Smishing/Etc](#phishingsmishingetc)
    + [Evilginx 3.0](#evilginx-30)
    + [EvilGoPhish](#evilgophish)
    + [Gophish](#gophish)
  * [Stealth](#stealth)
    + [FireProx](#fireprox)
    + [Mubeng](#mubeng)
    + [Proxycannon-ng](#proxycannon-ng)
- [Burp Suite Extensions (Doesn't Automatically Install)](#burp-suite-extensions-doesnt-automatically-install)
    + [Active Scan++](#active-scan)
    + [Additional Scanner Checks](#additional-scanner-checks)
    + [Agartha LFI, RCE, SQLi, Auth, HTTP to JS](#agartha-lfi-rce-sqli-auth-http-to-js)
    + [AutoRepeater](#autorepeater)
    + [Autorize](#autorize)
    + [Burp Bounty Scan Check Builder](#burp-bounty-scan-check-builder)
    + [Burp VPS Proxy](#burp-vps-proxy)
    + [Collaborator Everywhere](#collaborator-everywhere)
    + [Content Type Convertor](#content-type-convertor)
    + [CORS Additional Checks](#cors-additional-checks)
    + [Error Message Checks](#error-message-checks)
    + [Flow](#flow)
    + [Freddy Deserialization Bug Finder](#freddy-deserialization-bug-finder)
  * [GAP](#gap)
    + [GatherContacts](#gathercontacts)
    + [HTTP Request Smuggler](#http-request-smuggler)
    + [IPRotate](#iprotate)
    + [Java Deserialization Scanner](#java-deserialization-scanner)
    + [InQL - GraphQL Scanner](#inql---graphql-scanner)
    + [JS Miner](#js-miner)
    + [JSON Web Tokens](#json-web-tokens)
    + [Param Miner](#param-miner)
    + [Scavenger](#scavenger)
    + [Software Vulnerability Scanner](#software-vulnerability-scanner)
    + [SQLiPy Sqlmap Integration](#sqlipy-sqlmap-integration)
    + [Reflected Parameters](#reflected-parameters)
    + [Turbo Intruder](#turbo-intruder)
- [Firefox Browser Extensions (Doesn't Automatically Install)](#firefox-browser-extensions-doesnt-automatically-install)
    + [BuiltWith](#builtwith)
    + [Cookie-Editor](#cookie-editor)
    + [FoxyProxy](#foxyproxy)
    + [Firefox Multi-Account Containers](#firefox-multi-account-containers)
    + [HackTools](#hacktools)
    + [Open Multiple URLs](#open-multiple-urls)
    + [PwnFox](#pwnfox)
    + [Shodan](#shodan)
    + [Wappalyzer](#wappalyzer)
    + [WhatRuns](#whatruns)

# Enumeration & Recon Tools
## Ad & Analytic Trackers
### relations.sh
Find related domains and subdomains by looking at a target’s ad/analytics tracker codes
* https://gist.github.com/hateshape/393ab7003023f3b13126a4892100c8ff

![Google_Analytics_Tracking_Code](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/89a9192a-e9ea-4847-96e6-7b30827d9812)

## Apex Domain Enumeration
### check_mdi
Python script to enumerate valid Microsoft 365 domains, retrieve tenant name, and check for a Microsoft Defender for Identity (MDI) instance.
* https://github.com/expl0itabl3/check_mdi

![Fpg1kqZWABgCJGx](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/9c60b863-4c6c-4fba-b631-5e3b325cfd9c)

### CloudRecon
Finding assets and subdomains from certificates! Scan the web! 
* https://github.com/g0ldencybersec/CloudRecon

![324196773-8fe87016-1459-4d3a-a964-6b169325ec8c](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/9190fd8b-8017-44f2-a14b-4dbd9f9d8b8d)

### FavFreak
Use favicon.ico hashes for finding new assets/IP addresses and technologies owned by a company.
* https://github.com/devanshbatham/FavFreak

![68747470733a2f2f63646e2d696d616765732d312e6d656469756d2e636f6d2f6d61782f313230302f312a737176314b4c6f354242614c4b5347535577465566772e706e67](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/2aeb847e-f3fe-4a7f-a653-8b4236c5d391)

## Archival Enumeration
### gau
getallurls (gau) fetches known URLs from AlienVault's Open Threat Exchange, the Wayback Machine, Common Crawl, and URLScan for any given domain. Inspired by Tomnomnom's waybackurls.
* https://github.com/lc/gau

![25](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/a32b9a37-e4b0-496b-bc4f-1de72b74691a)

### WayMore
The idea behind waymore is to find even more links from the Wayback Machine than other existing tools. The biggest difference between waymore and other tools is that it can also download the archived responses for URLs on wayback machine so that you can then search these for even more links, developer comments, extra parameters, etc. 
* https://github.com/xnl-h4ck3r/waymore

![example1](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/b56aa31b-7a10-4c05-95c7-597d044574b9)

## Change Detection
### changedetection.io
The best and simplest free open source web page change detection, website watcher, restock monitor and notification service. Restock Monitor, change detection. Designed for simplicity - Simply monitor which websites had a text change for free. Free Open source web page change detection, Website defacement monitoring, Price change notification. Trigger notifications via Discord, Email, Slack, Telegram, API calls and many more. 
* https://github.com/dgtlmoon/changedetection.io

![screenshot](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/fb368f05-76a9-4052-a98a-714596a217e6)

## Credential Collection Tools (emails, usernames, passwords, etc)
### deepdarkCTI
The aim of this project is to collect the sources, present in the Deep and Dark web, which can be useful in Cyber Threat Intelligence contexts. You can try to infiltrate these communities and make friends in low place, many of which sell leaked credentials.
* https://github.com/fastfire/deepdarkCTI/tree/main
* https://github.com/fastfire/deepdarkCTI/blob/main/forum.md
* https://github.com/fastfire/deepdarkCTI/blob/main/discord.md

![image](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/eecebddb-1930-451f-9291-1d4a504c6765)

### h8mail
h8mail is an email OSINT and breach hunting tool using different breach and reconnaissance services, or local breaches such as Troy Hunt's "Collection1" and the infamous "Breach Compilation" torrent.
* https://github.com/khast3x/h8mail

![image](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/4c333770-a8e9-4aa6-97b7-defb6f4ecfc0)

### hacxx-underground
Directory for Hacxx Underground files (leaked credentials from database)
* https://github.com/hacxx-underground/Files

![image](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/d59b05cd-8588-4f05-bd55-d962e28913b8)

### linkedin2username
OSINT Tool: Generate username lists from companies on LinkedIn.
* https://github.com/initstring/linkedin2username

![drawing](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/0e3fcd55-7754-4cea-a72f-1f4e2900f663)

### WeakestLink
Scrapes employees from a LinkedIn company page, performs a number of clean up steps to remove any junk and then generates a range of possible username formats so they can be used in username enumeration and password attacks.
* https://github.com/shellfarmer/WeakestLink

![LinkedIn_Logo svg](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/39fac0d6-a29b-47d1-845c-030252beaaf9)

## Custom Wordlists
### CeWL
CeWL is a ruby app which spiders a given URL to a specified depth, optionally following external links, and returns a list of words which can then be used for password crackers such as John the Ripper.
* https://github.com/digininja/CeWL

![4](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/3215d3bb-3169-4863-9787-2f1a3c66b7e1)

### wordlistgen
wordlistgen is a tool to pass a list of URLs and get back a list of relevant words for your wordlists. Wordlists are much more effective when you take the application's context into consideration. wordlistgen pulls out URL components, such as subdomain names, paths, query strings, etc. and spits them back to stdout so you can easily add them to your wordlists
* https://github.com/ameenmaali/wordlistgen

![image](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/e4158b6d-3b9b-4776-b054-5013f9220b18)

## Directory Enumeration
### Dirsearch
An advanced web path brute-forcer.
* https://github.com/maurosoria/dirsearch

![pause](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/ede10f72-21dd-46bb-a42a-2fb8c3b9c205)

### Feroxbuster
A simple, fast, recursive content discovery tool written in Rust.
* https://github.com/epi052/feroxbuster

![demo](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/dafc386f-2f5a-418c-82ac-fe3b4badce8a)

### ffuf
A fast web fuzzer written in Go.
* https://github.com/ffuf/ffuf

![68747470733a2f2f61736369696e656d612e6f72672f612f3231313335302e706e67](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/f26e61b9-d270-4a05-8ecc-28fd1148ba3c)

### Gobuster
Gobuster is a tool used to brute-force: URIs (directories and files) in web site, DNS subdomains (with wildcard support), Virtual Host names on target web server, Open Amazon S3 buckets, Open Google Cloud buckets, and TFTP servers.
* https://github.com/OJ/gobuster

![GoBuster-Directory-File-DNS-Busting-Tool-in-Go-1024x560](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/0feb7647-9bd3-4565-a8b8-7e805e9562cc)

### Wfuzz
Wfuzz has been created to facilitate the task in web applications assessments and it is based on a simple concept: it replaces any reference to the FUZZ keyword by the value of a given payload. This simple concept allows any input to be injected in any field of an HTTP request, allowing to perform complex web security attacks in different web application components such as: parameters, authentication, forms, directories/files, headers, etc.
* https://github.com/xmendez/wfuzz

![wfuzz1](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/6b0a8fbd-bb16-4fa1-b052-b6c42401c0c4)

## Github Enumeration
### github-search
Perform code search through GitHub API. Finds contributors, dorks, employees, endpoints, secrets, subdomains, users, etc. 
* https://github.com/gwen001/github-search

![github-search](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/0a689973-fac3-4e25-9479-c25eae0ca733)

### GitLeaks
Gitleaks is a SAST tool for detecting and preventing hardcoded secrets like passwords, api keys, and tokens in git repos. Gitleaks is an easy-to-use, all-in-one solution for detecting secrets, past or present, in your code.
* https://github.com/gitleaks/gitleaks

![travis_fail](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/8f414393-a1ac-4449-9ca8-07a2881b5ae2)

## JavaScript
### jsluice
jsluice is a Go package and command-line tool for extracting URLs, paths, secrets, and other interesting data from JavaScript source code.
* https://github.com/BishopFox/jsluice

![F1NlsesXsAEJsIu](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/8d95fddb-21d9-43b5-8d69-d49557c4c8eb)

### Linkfinder
LinkFinder is a python script written to discover endpoints and their parameters in JavaScript files. This way penetration testers and bug hunters are able to gather new, hidden endpoints on the websites they are testing. Resulting in new testing ground, possibility containing new vulnerabilities.
* https://github.com/GerbenJavado/LinkFinder

![62728809-f98b0900-ba1c-11e9-8dd8-67111263a21f](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/81230d6c-0fe4-495c-b81d-9573b817ebeb)

## Mobile App Enumeration
### APKLeaks
Scanning APK file for URIs, endpoints & secrets.
* https://github.com/dwisiswant0/apkleaks

![111927529-a4ade080-8ae3-11eb-800a-b764ab1242e1](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/d69e2a36-9f09-4ab5-bdff-291ac11cd883)

## Port Scanners (Active)
### AutoRecon
AutoRecon is a multi-threaded network reconnaissance tool which performs automated enumeration of services. It is intended as a time-saving tool for use in CTFs and other penetration testing environments (e.g. OSCP). It may also be useful in real-world engagements. The tool works by firstly performing port scans / service detection scans. From those initial results, the tool will launch further enumeration scans of those services using a number of different tools. For example, if HTTP is found, feroxbuster will be launched. Runs curl, dnsrecon, enum4linux, feroxbuster, gobuster, impacket-scripts, nbtscan, nikto, nmap, onesixtyone, oscanner, redis-tools, smbclient, smbmap, snmpwalk, sslscan, svwar, tnscmd10g, whatweb, wkhtmltopdf, etc automatically. 
* https://github.com/Tib3rius/AutoRecon

![frst-scan](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/526d625e-2a50-439a-a23f-36679e079dd5)

### MASSCAN
This is an Internet-scale port scanner. It can scan the entire Internet in under 5 minutes, transmitting 10 million packets per second, from a single machine.
* https://github.com/robertdavidgraham/masscan

![masscan-examples](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/c7175285-38df-441f-9c7d-65dc2a70f82f)

### Naabu
Naabu is a port scanning tool written in Go that allows you to enumerate valid ports for hosts in a fast and reliable manner. It is a really simple tool that does fast SYN/CONNECT/UDP scans on the host/list of hosts and lists all ports that return a reply. Most usable port scanner.
* https://github.com/projectdiscovery/naabu

![180417395-25b1b990-c032-4b5c-9b66-03b58db0789a](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/6259ec60-d179-451f-8cfb-b1fa3ad7ca8f)

### Nmap
Most extensible scanner.
* https://github.com/nmap/nmap

![image](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/b785b1bc-2fc0-4bc8-bda4-3f7de4153368)

### RustScan
RustScan is empirically the fastest modern port scanner.
* https://github.com/RustScan/RustScan

![fast](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/07ee2643-76d3-4023-aa14-c91b5568336e)

## Port Scanners (Passive) 
### Smap
Smap is a port scanner built with shodan.io's free API. It takes same command line arguments as Nmap and produces the same output which makes it a drop-in replacament for Nmap.
* https://github.com/s0md3v/Smap

![smap-demo](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/add08959-8071-46df-9852-dbbeaade4deb)

## Recon Frameworks
### reconFTW
reconFTW automates the entire process of reconnaissance for you. It outperforms the work of subdomain enumeration along with various vulnerability checks and obtaining maximum information about your target.
* https://github.com/six2dez/reconftw

![mindmap_obsidian](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/d39f578b-eeeb-4741-a131-efe8de6eae11)

### Recon-ng
Recon-ng is a full-featured reconnaissance framework designed with the goal of providing a powerful environment to conduct open source web-based reconnaissance quickly and thoroughly.
* https://github.com/lanmaster53/recon-ng

### reNgine
reNgine is your go-to web application reconnaissance suite that's designed to simplify and streamline the reconnaissance process for security professionals, penetration testers, and bug bounty hunters. With its highly configurable engines, data correlation capabilities, continuous monitoring, database-backed reconnaissance data, and an intuitive user interface, reNgine redefines how you gather critical information about your target web applications. 
* https://github.com/yogeshojha/rengine

![164993749-1ad343d6-8ce7-43d6-aee7-b3add0321da7](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/efed20d0-285a-4fd2-857d-f3ffe5f3e0c4)

## Shodan Tools
### karma v2
𝚔𝚊𝚛𝚖𝚊 𝚟𝟸 can be used by Infosec Researchers, Penetration Testers, Bug Hunters to find deep information, more assets, WAF/CDN bypassed IPs, Internal/External Infra, Publicly exposed leaks and many more about their target. Shodan Premium API key is required to use this automation. Output from the 𝚔𝚊𝚛𝚖𝚊 𝚟𝟸 is displayed to the screen and saved to files/directories. 
* https://github.com/Dheerajmadhukar/karma_v2

![image](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/2f317bed-b64f-4067-a848-e5e621429b1c)

### shosubgo
Small tool to Grab subdomains using Shodan api.
* https://github.com/incogbyte/shosubgo

![shosubgo](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/b29be12b-4a8b-4f19-a0a4-7e78836bc6fc)

### Smap
Smap is a port scanner built with shodan.io's free API. It takes same command line arguments as Nmap and produces the same output which makes it a drop-in replacament for Nmap.
* https://github.com/s0md3v/Smap

![smap-demo](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/add08959-8071-46df-9852-dbbeaade4deb)

### wtfis
Passive hostname, domain and IP lookup tool for non-robots.
* https://github.com/pirxthepilot/wtfis

![demo](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/11088982-3350-48ec-a070-b913e3bbcdca)

## Screenshotting
### Aquatone
Aquatone is a tool for visual inspection of websites across a large amount of hosts and is convenient for quickly gaining an overview of HTTP-based attack surface.
* https://github.com/michenriksen/aquatone

![rszscreenshot280](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/ef2532ae-4c9e-40b3-95df-81a09ff0d508)

### Eyeballer
Eyeballer is meant for large-scope network penetration tests where you need to find "interesting" targets from a huge set of web-based hosts. Go ahead and use your favorite screenshotting tool like normal (EyeWitness or GoWitness) and then run them through Eyeballer to tell you what's likely to contain vulnerabilities, and what isn't.
* https://github.com/BishopFox/eyeballer

![eyeballer_logo](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/7627421d-aaca-44fa-b397-8fc2af6ef98e)

### EyeWitness
EyeWitness is designed to take screenshots of websites provide some server header info, and identify default credentials if known.
* https://github.com/RedSiege/EyeWitness

![image](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/27da8e8a-a63b-418c-ab9a-c9131b3fdd80)

### go-stare
A fast & light web screenshot without headless browser but Chrome DevTools Protocol!
* https://github.com/dwisiswant0/go-stare

![94014291-86398780-fdd5-11ea-803d-4eb3ec64bd7b](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/af9d996a-e4a6-4e14-9504-5ccdc7676cd6)

### httpscreenshot
HTTPScreenshot is a tool for grabbing screenshots and HTML of large numbers of websites. The goal is for it to be both thorough and fast which can sometimes oppose each other.
* https://github.com/breenmachine/httpscreenshot

![image](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/edd505fc-d48f-47de-bddf-50c4913560cd)

### httpx
httpx is a fast and multi-purpose HTTP toolkit that allows running multiple probes using the retryablehttp library. It is designed to maintain result reliability with an increased number of threads.
* https://github.com/projectdiscovery/httpx

![135731750-4c1d38b1-bd2a-40f9-88e9-3c4b9f6da378](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/58e90897-e35c-4e6a-ad80-40fc79e50b90)

## Spiders
### GoSpider is a fast web spider written in Go
* https://github.com/jaeles-project/gospider

![Example12](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/b741fa50-f7a9-4cc1-97d4-5dc37e8026bd)

## katana
A next-generation crawling and spidering framework
* https://github.com/projectdiscovery/katana

![image](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/17cdddd4-f5ba-43c1-8449-4cfaadb10339)

### hakrawler
Fast golang web crawler for gathering URLs and JavaScript file locations. This is basically a simple implementation of the awesome Gocolly library.
* https://github.com/hakluke/hakrawler

![1 kpuT3tZ7bS5qSLJPQa_7IQ](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/16ebc455-da68-4f32-a78e-d744f50122cc)

## Subdomain Enumeration and Brute Force
### Altdns
Altdns is a DNS recon tool that allows for the discovery of subdomains that conform to patterns. Altdns takes in words that could be present in subdomains under a domain (such as test, dev, staging) as well as takes in a list of subdomains that you know of.
* https://github.com/infosec-au/altdns

![68747470733a2f2f692e696d6775722e636f6d2f4a7966756532362e706e67](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/2de07fcf-2473-4854-b92d-d9dfe4234463)

### AlterX
Fast and customizable subdomain wordlist generator using DSL.
* https://github.com/projectdiscovery/alterx

![229380735-140d3f25-d0cb-461d-8c49-4c1eff43d1f4](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/653389cb-db3f-486d-92fe-aabf48da7c5f)

### Amass
The OWASP Amass Project performs network mapping of attack surfaces and external asset discovery using open source information gathering and active reconnaissance techniques.
* https://github.com/owasp-amass/amass

![image](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/2d260a63-e529-444d-aadb-7099d59a8b01)

### assetfinder
Find domains and subdomains potentially related to a given domain.
* https://github.com/tomnomnom/assetfinder

![Example1min](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/939e97f4-de11-4893-ab67-637a9377fd6f)

### BBOT
BBOT (Bighuge BLS OSINT Tool) is a recursive internet scanner inspired by Spiderfoot, but designed to be faster, more reliable, and friendlier to pentesters, bug bounty hunters, and developers.
* https://github.com/blacklanternsecurity/bbot

![296080072-53e07e9f-50b6-4b70-9e83-297dbfbcb436](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/3250d9e2-a31e-40a6-b08a-0744aeb3ced8)

### CloudRecon
Finding assets and subdomains from certificates! Scan the web! 
* https://github.com/g0ldencybersec/CloudRecon

![324196773-8fe87016-1459-4d3a-a964-6b169325ec8c](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/9190fd8b-8017-44f2-a14b-4dbd9f9d8b8d)

### dnsgen
This tool generates a combination of domain names from the provided input. Combinations are created based on wordlist. Custom words are extracted per execution.
* https://github.com/AlephNullSK/dnsgen

![68747470733a2f2f307870617472696b2e636f6d2f636f6e74656e742f696d616765732f323031392f30392f646e7367656e2d312e706e67](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/15a9dd87-f5b1-4537-b20d-417813dbf802)

### FavFreak
Use favicon.ico hashes for finding new assets/IP addresses and technologies owned by a company.
* https://github.com/devanshbatham/FavFreak

![68747470733a2f2f63646e2d696d616765732d312e6d656469756d2e636f6d2f6d61782f313230302f312a737176314b4c6f354242614c4b5347535577465566772e706e67](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/2aeb847e-f3fe-4a7f-a653-8b4236c5d391)

### Findomain
Findomain offers a subdomains monitoring service that provides directory fuzzing, port scanning, vulnerability discovery, and more.
* https://github.com/Findomain/Findomain

![findomain](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/678315dd-a520-4e50-ac4c-c6fc5ae6bb2d)

### github-subdomains
This Go tool performs searches on GitHub and parses the results to find subdomains of a given domain. May have to run several times to get complete results.
* https://github.com/gwen001/github-subdomains

![preview](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/82c6bbc7-2520-463f-a4a2-73e2687f1924)

### Gotator
Gotator is a tool to generate DNS wordlists through permutations. 
* https://github.com/Josue87/gotator

![122590788-510b4e80-d062-11eb-8eb7-9f0a2cf36ea9](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/09d2960b-0942-4249-ac63-d95c76b7cd6f)

### puredns
puredns is a fast domain resolver and subdomain bruteforcing tool that can accurately filter out wildcard subdomains and DNS poisoned entries.
* https://github.com/d3mondev/puredns

![puredns-terminal](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/63f23c67-331d-47b1-9756-36665b265e5a)

## REGULATOR
Automated learning of regexes for DNS discovery
* https://github.com/cramppet/regulator

![image](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/004f27b3-b100-4d56-b7b9-640904b493e2)

### Shuffledns
massDNS wrapper to bruteforce and resolve the subdomains with wildcard handling support
* https://github.com/projectdiscovery/shuffledns

![shuffledns-run](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/d7a616bf-bb93-4346-a1f8-a240e66dc440)

### shosubgo
Small tool to Grab subdomains using Shodan api.
* https://github.com/incogbyte/shosubgo

![shosubgo](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/b29be12b-4a8b-4f19-a0a4-7e78836bc6fc)

### Subfinder
Subdomain discovery tool that returns valid subdomains for websites, using passive online sources. It has a simple, modular architecture and is optimized for speed. 
* https://github.com/projectdiscovery/subfinder

![subfinder-run](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/adde8c28-c77a-48b1-84c6-9744c042eec9)

### Sublist3r
Sublist3r is a python tool designed to enumerate subdomains of websites using OSINT. It helps penetration testers and bug hunters collect and gather subdomains for the domain they are targeting. Sublist3r enumerates subdomains using many search engines such as Google, Yahoo, Bing, Baidu and Ask. Sublist3r also enumerates subdomains using Netcraft, Virustotal, ThreatCrowd, DNSdumpster and ReverseDNS.
* https://github.com/aboul3la/Sublist3r

![Screenshot_2020-07-06_01-47-21](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/d42509dd-cdb7-4c4e-b0af-59c11c2cd798)

## Web Technology Enumeration
### webanalyze
This is a port of Wappalyzer in Go. This tool is designed to be performant and allows to test huge lists of hosts.
* https://github.com/rverton/webanalyze

![image](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/601af95f-70dc-428b-8e4b-1a0b661d8885)

### WhatWeb
WhatWeb identifies websites. Its goal is to answer the question, "What is that Website?". WhatWeb recognises web technologies including content management systems (CMS), blogging platforms, statistic/analytics packages, JavaScript libraries, web servers, and embedded devices. WhatWeb has over 1800 plugins, each to recognise something different. WhatWeb also identifies version numbers, email addresses, account IDs, web framework modules, SQL errors, and more.
* https://github.com/urbanadventurer/WhatWeb

![whatweb-aggressive1](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/dad37a75-c5f9-4a50-beab-8eeeaa85458f)

# Exploitation
## Active Directory
### Bloodhound
BloodHound uses graph theory to reveal the hidden and often unintended relationships within an Active Directory or Azure environment. Attackers can use BloodHound to easily identify highly complex attack paths that would otherwise be impossible to quickly identify. Defenders can use BloodHound to identify and eliminate those same attack paths. Both blue and red teams can use BloodHound to easily gain a deeper understanding of privilege relationships in an Active Directory or Azure environment.
* https://github.com/BloodHoundAD/BloodHound

![48985201-6f587a00-f105-11e8-8355-98e38e08cc5e](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/f6c595e4-2387-48fe-8cfa-da71be63ed7d)

### Empire
Empire is a post-exploitation framework that includes a pure-PowerShell2.0 Windows agent, and a pure Python 2.6/2.7 Linux/OS X agent. It is the merge of the previous PowerShell Empire and Python EmPyre projects. The framework offers cryptologically-secure communications and a flexible architecture. On the PowerShell side, Empire implements the ability to run PowerShell agents without needing powershell.exe, rapidly deployable post-exploitation modules ranging from key loggers to Mimikatz, and adaptable communications to evade network detection, all wrapped up in a usability-focused framework.
* https://github.com/EmpireProject/Empire

![image](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/ce2c65ac-51f4-476b-afae-d049f3fa0b58)

### Powersploit
PowerSploit is a collection of Microsoft PowerShell modules that can be used to aid penetration testers during all phases of an assessment. PowerSploit is comprised of the following modules and scripts:
* https://github.com/PowerShellMafia/PowerSploit

![kali](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/10995d43-3639-4d60-806e-06b65befd922)

## Linux Privilege Escalation
### LinEnum
Enumerate Linux OS to find privilege escalation
* https://github.com/rebootuser/LinEnum

![image](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/e1b8ffaf-79c1-4a6e-b144-eee695977be3)

### LinPEAS
Linux Privilege Escalation Awesome Script
* https://github.com/peass-ng/PEASS-ng/tree/master/linPEAS

![linpeas](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/47a2a4aa-b28c-4aa9-bc09-b258b8a00d70)

### linuxprivcheck
Python script for privilege escalation for Linux
* https://github.com/cervoise/linuxprivcheck

![image](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/f64b7e3f-669e-4664-89a7-123ee95df39b)

### Linuxprivchecker.py
This script is intended to be executed locally on a Linux box to enumerate basic system info and search for common privilege escalation vectors such as world writable files, misconfigurations, clear-text passwords and applicable exploits.
* https://github.com/sleventyeleven/linuxprivchecker

![finding-privilege-escalation-flaws-in-linux-by-using-linuxprivchecker-script-and-escalating-privileges-on-a-misconfigured-mysql-database-by-using-user-defined-functions-raptor-udf-18](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/6c75bd11-8795-467e-b68b-756d488b686a)

## Password Spraying, Stuffing, Brute Forcing, Cracking, etc
### CredMaster
Launch a password spray / brute force attach via Amazon AWS passthrough proxies, shifting the requesting IP address for every authentication attempt. This dynamically creates FireProx APIs for more evasive password sprays.
* https://github.com/knavesec/CredMaster

![credmaster-default](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/a17b98a7-5da0-448c-8b6c-cfd77282f266)

### Hashchat
hashcat is the world's fastest and most advanced password recovery utility, supporting five unique modes of attack for over 300 highly-optimized hashing algorithms. hashcat currently supports CPUs, GPUs, and other hardware accelerators on Linux, Windows, and macOS, and has facilities to help enable distributed password cracking.
* https://github.com/hashcat/hashcat

![image](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/61534428-1e76-456e-b300-97002d063da7)

### Hydra
Number one of the biggest security holes are passwords, as every password security study shows. This tool is a proof of concept code, to give researchers and security consultants the possibility to show how easy it would be to gain unauthorized access from remote to a system.
* https://github.com/vanhauser-thc/thc-hydra

![hydra-4-f](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/d4521428-f527-4416-bf29-648233ea292c)

### John the Ripper
This is the community-enhanced, "jumbo" version of John the Ripper. It has a lot of code, documentation, and data contributed by jumbo developers and the user community. It is easy for new code to be added to jumbo, and the quality requirements are low, although lately we've started subjecting all contributions to quite some automated testing. This means that you get a lot of functionality that is not necessarily "mature", which in turn means that bugs in this code are to be expected.
* https://github.com/openwall/john

![John_the_Ripper_example-quick](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/15b1f132-703c-40a8-a9f7-61af0f6d30bb)

### Medusa
Medusa is a speedy, parallel, and modular, login brute-forcer. The goal is to support as many services which allow remote authentication as possible.
* https://github.com/jmk-foofus/medusa

![Picture4](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/7ee498e4-433d-4a46-8401-f8baf63098a0)

### WhereToGo
Due to security assessments of different projects, I found different leaked/exposed accounts on the domain of the organization. But every time it was so difficult to discover the place where I can reuse those credentials and how can I expand my attack surface. I started collecting a list of popular technological services which might have high value in case of improper access. This project should help researchers, pentesters, bounty-hunters to expand the risks of compromised accounts in the corporate environment.
* https://github.com/valeriyshevchenko90/WhereToGo

![image](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/ba5930fe-0cac-4bb2-8b06-ead1058dc905)

## Payload Lists
### Payloads All The Things
A list of useful payloads and bypasses for Web Application Security. Feel free to improve with your payloads and techniques!
* https://github.com/swisskyrepo/PayloadsAllTheThings

![banner](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/365bf3af-e65d-41a1-b0da-0c1feb32db5f)

### SecLists
SecLists is the security tester's companion. It's a collection of multiple types of lists used during security assessments, collected in one place. List types include usernames, passwords, URLs, sensitive data patterns, fuzzing payloads, web shells, and many more. The goal is to enable a security tester to pull this repository onto a new testing box and have access to every type of list that may be needed.
* https://github.com/danielmiessler/SecLists

![SecLists](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/43446307-91c0-456d-96f6-6ed704bc0609)

## Windows Privilege Escalation
### WES-NG
WES-NG is a tool based on the output of Windows' systeminfo utility which provides the list of vulnerabilities the OS is vulnerable to, including any exploits for these vulnerabilities. Every Windows OS between Windows XP and Windows 11, including their Windows Server counterparts, is supported.
* https://github.com/bitsadmin/wesng

![demo](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/bc87cc03-bc5a-42a6-9101-b9bd88ebb504)

### winPEAS
Windows Privilege Escalation Awesome Scripts
* https://github.com/peass-ng/PEASS-ng/tree/master/winPEAS

![winpeas](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/c5605b24-23b0-43f2-81f9-82b955a5b2de)

## SQL Injection
### Ghauri
An advanced cross-platform tool that automates the process of detecting and exploiting SQL injection security flaws.
* https://github.com/r0oth3x49/ghauri

![193408429-418a75e0-a070-4491-9f92-5799b2509cdf](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/f86f5361-3d42-447d-b10a-9021cc893b25)

### HBSQLI
HBSQLI is an automated command-line tool for performing Header Based Blind SQL injection attacks on web applications. It automates the process of detecting Header Based Blind SQL injection vulnerabilities, making it easier for security researchers , penetration testers & bug bounty hunters to test the security of web applications. 
* https://github.com/SAPT01/HBSQLI

![236712050-d4d71f91-9793-4c3e-adcd-b7bdef1ab487](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/bd38ebac-ca5e-4a56-b65f-516debd415a9)

### sqlmap
sqlmap is an open source penetration testing tool that automates the process of detecting and exploiting SQL injection flaws and taking over of database servers. It comes with a powerful detection engine, many niche features for the ultimate penetration tester, and a broad range of switches including database fingerprinting, over data fetching from the database, accessing the underlying file system, and executing commands on the operating system via out-of-band connections.
* https://github.com/sqlmapproject/sqlmap

![68747470733a2f2f7261772e6769746875622e636f6d2f77696b692f73716c6d617070726f6a6563742f73716c6d61702f696d616765732f73716c6d61705f73637265656e73686f742e706e67](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/1dee8d4f-5d3a-4239-9602-335a1a4ac307)

## Vulnerability Scanners
### Jaeles
Jaeles is a powerful, flexible and easily extensible framework written in Go for building your own Web Application Scanner. You can also integrate it into Burp Suite.
* https://github.com/jaeles-project/jaeles

![jaeles-architecture](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/25fdf104-2c90-4dbe-bfcd-072622847557)

### Nuclei 
Nuclei is used to send requests across targets based on a template, leading to zero false positives and providing fast scanning on a large number of hosts. Nuclei offers scanning for a variety of protocols, including TCP, DNS, HTTP, SSL, File, Whois, Websocket, Headless, Code etc. With powerful and flexible templating, Nuclei can be used to model all kinds of security checks.
* https://github.com/projectdiscovery/nuclei
* https://github.com/AggressiveUser/AllForOne
* https://github.com/xm1k3/cent

![nuclei-flow](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/103ff11d-c191-4446-88a7-ad45609dc581)

### Retire.js
There is a plethora of JavaScript libraries for use on the Web and in Node.JS apps out there. This greatly simplifies development,but we need to stay up-to-date on security fixes. "Using Components with Known Vulnerabilities" is now a part of the OWASP Top 10 list of security risks and insecure libraries can pose a huge risk to your Web app. The goal of Retire.js is to help you detect the use of JS-library versions with known vulnerabilities.
* https://github.com/retirejs/retire.js/

![image](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/8dd7a572-5ceb-4b4a-a79d-29cb9f642391)

# Red Teaming
## C2
### NimPlant
A light first-stage C2 implant written in Nim and Python.
* https://github.com/chvancooten/NimPlant

![nimplant-web](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/c7ed6723-147d-48d5-87a3-7d64cbdc96d1)

### SharpC2
SharpC2 is a Command & Control (C2) framework written in C#. It consists of an ASP.NET Core Team Server, a .NET Framework implant, and a .NET MAUI client.
* https://github.com/rasta-mouse/SharpC2

![screenshot](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/1d87e69c-a60c-4253-b081-2f8d8e55580d)

## Distribution
### Axiom
Axiom is a dynamic infrastructure framework to efficiently work with multi-cloud environments, build and deploy repeatable infrastructure focused on offensive and defensive security. Because you can create many disposable instances very easily, axiom allows you to distribute scans of many different tools. 
* https://github.com/pry0cc/axiom

![axiom-init-demo](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/c4251aa3-8127-4f45-ab77-40afaf7ad660)

### Fleex
Fleex allows you to create multiple VPS on cloud providers and use them to distribute your workload. Run tools like masscan, puredns, ffuf, httpx or anything you need and get results quickly!
* https://github.com/FleexSecurity/fleex

![68747470733a2f2f666c65657873656375726974792e6769746875622e696f2f666c6565782d646f63732f6769662f666c6565785f696e74726f2e676966](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/17873ec1-8ae7-4a43-8aa9-8228476f2c56)

### ShadowClone
ShadowClone allows you to distribute your long running tasks dynamically across thousands of serverless functions and gives you the results within seconds where it would have taken hours to complete.
* https://github.com/fyoorer/ShadowClone

![image](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/80724481-d097-4a29-9514-ba655fda211f)

## Phishing/Smishing/Etc
### Evilginx 3.0
Evilginx is a man-in-the-middle attack framework used for phishing login credentials along with session cookies, which in turn allows to bypass 2-factor authentication protection.
* https://github.com/kgretzky/evilginx2

![screen](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/2b4f35c3-8142-4ff2-bf4a-38db478eabae)

### EvilGoPhish
In this setup, GoPhish is used to send emails and provide a dashboard for evilginx3 campaign statistics, but it is not used for any landing pages. Your phishing links sent from GoPhish will point to an evilginx3 lure path and evilginx3 will be used for landing pages. This provides the ability to still bypass 2FA/MFA with evilginx3, without losing those precious stats. Supports phishing + smishing. 
* https://github.com/fin3ss3g0d/evilgophish

![image](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/f883b301-f3f9-4b10-bb26-341016afdc32)

### Gophish
Gophish is an open-source phishing toolkit designed for businesses and penetration testers. It provides the ability to quickly and easily setup and execute phishing engagements and security awareness training.
* https://github.com/gophish/gophish

![68747470733a2f2f7261772e6769746875622e636f6d2f676f70686973682f676f70686973682f6d61737465722f7374617469632f696d616765732f676f70686973685f707572706c652e706e67](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/7c018c71-101d-4b20-a080-1debda7cc673)

## Stealth
### FireProx
Being able to hide or continually rotate the source IP address when making web calls can be difficult or expensive. A number of tools have existed for some time but they were either limited with the number of IP addresses, were expensive, or required deployment of lots of VPS's. FireProx leverages the AWS API Gateway to create pass-through proxies that rotate the source IP address with every request! Use FireProx to create a proxy URL that points to a destination server and then make web requests to the proxy URL which returns the destination server response!
* https://github.com/ustayready/fireprox

![usage](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/305d9746-cc16-42af-8fed-eb37b1763131)

### Mubeng
An incredibly fast proxy checker & IP rotator with ease.
* https://github.com/kitabisa/mubeng

![180201570-4b8f3609-4285-4f27-9dff-e1d0e06c4413](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/28300f62-103a-4fa6-8b6c-391bfd52bec0)

### Proxycannon-ng
The control-server is a OpenVPN server that your workstation will connect to. This server always remains up. Exit-nodes are systems connected to the control-server that provides load balancing and multiple source IP addresses. Exit-nodes can scale up and down to suite your needs.
* https://github.com/proxycannon/proxycannon-ng

![68747470733a2f2f696d672e796f75747562652e636f6d2f76692f444c62306c4e38647070592f302e6a7067](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/0c40e572-6d35-4cac-bb40-ab3d5cd390c2)

# Burp Suite Extensions (Doesn't Automatically Install)
### Active Scan++
ActiveScan++ extends Burp Suite's active and passive scanning capabilities. Designed to add minimal network overhead, it identifies application behaviour that may be of interest to advanced testers.
* https://portswigger.net/bappstore/3123d5b5f25c4128894d97ea1acc4976

### Additional Scanner Checks
This extension provides some additional passive Scanner checks such as: DOM-based XSS, HTTP -> HTTPS redirection, missing HTTP headres, and more. 
* https://portswigger.net/bappstore/a158fd3fc9394253be3aa0bc4c181d1f

### Agartha LFI, RCE, SQLi, Auth, HTTP to JS
Agartha creates payloads to reveal injection flaws, generates user request/response tables to spot access violations, and converts Http requests to JavaScript code for further XSS exploitation.
* https://portswigger.net/bappstore/b4915681326648b1a12e4059d71bc909

### AutoRepeater
This extension automatically repeats requests, with replacement rules and response diffing. It provides a general-purpose solution for streamlining authorization testing within web applications.
* https://portswigger.net/bappstore/f89f2837c22c4ab4b772f31522647ed8

### Autorize
Autorize is an extension aimed at helping the penetration tester to detect authorization vulnerabilities, one of the more time-consuming tasks in a web application penetration test. It is sufficient to give to the extension the cookies of a low privileged user and navigate the website with a high privileged user. The extension automatically repeats every request with the session of the low privileged user and detects authorization vulnerabilities. It is also possible to repeat every request without any cookies in order to detect authentication vulnerabilities in addition to authorization ones.
* https://portswigger.net/bappstore/f9bbac8c4acf4aefa4d7dc92a991af2f

### Burp Bounty Scan Check Builder
This BurpSuite extension allows you, in a quick and simple way, to improve the active and passive BurpSuite scanner by means of personalized rules through a very intuitive graphical interface. Through an advanced search of patterns and an improvement of the payload to send, we can create our own issue profiles both in the active scanner and in the passive.
* https://portswigger.net/bappstore/618f0b2489564607825e93eeed8b9e0a

### Burp VPS Proxy
Burp VPS Proxy is a Burp Suite extension that allows for the automatic creation and deletion of upstream SOCKS5 proxies on popular cloud providers from within Burp Suite. It automatically configures Burp to use the created proxy so that all outbound traffic comes from a cloud IP address. This is useful to prevent our main IP address from being blacklisted by popular WAFs while performing penetration testing and bug bounty hunting.
* https://github.com/d3mondev/burp-vps-proxy

### Collaborator Everywhere
This extension augments your in-scope proxy traffic by injecting non-invasive headers designed to reveal backend systems by causing pingbacks to Burp Collaborator.
* https://portswigger.net/bappstore/2495f6fb364d48c3b6c984e226c02968

### Content Type Convertor
This extension converts data submitted within requests between various common formats. This is useful for discovering vulnerabilities that can only be found by converting the content type of a request.
* https://portswigger.net/bappstore/db57ecbe2cb7446292a94aa6181c9278

### CORS Additional Checks
This extension can be used to test websites for CORS misconfigurations. It can spot trivial misconfigurations, like arbitrary origin reflection, but also more subtle ones where a regex is not properly configured.
* https://portswigger.net/bappstore/420a28400bad4c9d85052f8d66d3bbd8

### Error Message Checks
This extension passively reports detailed server error messages.
* https://portswigger.net/bappstore/4f01db4b668c4126a68e4673df796f0f

### Flow
This extension provides a Proxy history-like view along with search filter capabilities for all Burp tools. Requests without responses received are also shown and they are later updated as soon as response is received. This might be helpful to troubleshoot e.g. scanning issues.
* https://portswigger.net/bappstore/ee1c45f4cc084304b2af4b7e92c0a49d

### Freddy Deserialization Bug Finder
Helps with detecting and exploiting serialization in libraries and APIs.
* https://portswigger.net/bappstore/ae1cce0c6d6c47528b4af35faebc3ab3

## GAP
This is an evolution of the original getAllParams extension for Burp. Not only does it find more potential parameters for you to investigate, but it also finds potential links to try these parameters on, and produces a target specific wordlist to use for fuzzing. The full Help documentation can be found here or from the Help icon on the GAP tab.
* https://github.com/xnl-h4ck3r/GAP-Burp-Extension

![tab](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/d8adb465-2235-43ef-9850-064d0ade2e3c)

### GatherContacts
A Burp Suite Extension to pull Employee Names from Google and Bing LinkedIn Search Results.
* https://github.com/clr2of8/GatherContacts

### HTTP Request Smuggler
This is an extension for Burp Suite designed to help you launch HTTP Request Smuggling attacks. It supports scanning for Request Smuggling vulnerabilities, and also aids exploitation by handling cumbersome offset-tweaking for you.
* https://portswigger.net/bappstore/aaaa60ef945341e8a450217a54a11646

### IPRotate
This extension allows you to easily spin up API Gateways across multiple regions. All the Burp Suite traffic for the targeted host is then routed through the API Gateway endpoints which causes the IP to be different on each request. (There is a chance for recycling of IPs but this is pretty low and the more regions you use the less of a chance). This is useful to bypass different kinds of IP blocking like bruteforce protection that blocks based on IP, API rate limiting based on IP or WAF blocking based on IP etc.
* https://github.com/RhinoSecurityLabs/IPRotate_Burp_Extension

### Java Deserialization Scanner
The extension allows the user to discover and exploit Java Deserialization Vulnerabilities with different encodings (Raw, Base64, Ascii Hex, GZIP, Base64 GZIP).
* https://portswigger.net/bappstore/228336544ebe4e68824b5146dbbd93ae

### InQL - GraphQL Scanner
This Burp extension is designed to assist in your GraphQL security testing efforts.
* https://portswigger.net/bappstore/296e9a0730384be4b2fffef7b4e19b1f

### JS Miner
This tool tries to find interesting stuff inside static files; mainly JavaScript and JSON files. Scans for secrets, credentials, subdomains, cloud URLs, API endpoints, etc.
* https://portswigger.net/bappstore/0ab7a94d8e11449daaf0fb387431225b

### JSON Web Tokens
JSON Web Tokens (JWT4B) lets you decode and manipulate JSON web tokens on the fly, check their validity and automate common attacks.
* https://portswigger.net/bappstore/f923cbf91698420890354c1d8958fee6

### Param Miner
This extension identifies hidden, unlinked parameters. It's particularly useful for finding web cache poisoning vulnerabilities. It combines advanced diffing logic from Backslash Powered Scanner with a binary search technique to guess up to 65,536 param names per request. Param names come from a carefully curated built in wordlist, and it also harvests additional words from all in-scope traffic.
* https://portswigger.net/bappstore/17d2949a985c4b7ca092728dba871943

### Scavenger
Burp extension to create target specific and tailored wordlist from burp history.
* https://github.com/0xDexter0us/Scavenger

### Software Vulnerability Scanner
This extension scans for vulnerabilities in detected software versions using the Vulners.com API. 
* https://portswigger.net/bappstore/c9fb79369b56407792a7104e3c4352fb

### SQLiPy Sqlmap Integration
This extension integrates Burp Suite with SQLMap.
* https://portswigger.net/bappstore/f154175126a04bfe8edc6056f340f52e

### Reflected Parameters
This extension monitors traffic and looks for request parameter values (longer than 3 characters) that are reflected in the response.
* https://portswigger.net/bappstore/8e8f6bb313db46ba9e0a7539d3726651

### Turbo Intruder
Turbo Intruder is a Burp Suite extension for sending large numbers of HTTP requests and analyzing the results. It's intended to complement Burp Intruder by handling attacks that require extreme speed or complexity.
* https://portswigger.net/bappstore/9abaa233088242e8be252cd4ff534988

# Firefox Browser Extensions (Doesn't Automatically Install)
### BuiltWith
BuiltWith is a web site profiler tool. Upon looking up a page, BuiltWith returns a list all the technologies in use on that page that it can find.
* https://addons.mozilla.org/en-US/firefox/addon/builtwith/

### Cookie-Editor
Efficiently create, edit and delete a cookie for the current tab. Perfect for developing, quickly testing or even manually managing your cookies for your privacy.
* https://addons.mozilla.org/en-US/firefox/addon/cookie-editor/

### FoxyProxy
FoxyProxy is an open-source, advanced proxy management tool that completely replaces Firefox's limited proxying capabilities. No paid accounts are necessary; bring your own proxies or buy from any vendor.
* https://addons.mozilla.org/en-US/firefox/addon/foxyproxy-standard/

### Firefox Multi-Account Containers
Firefox Multi-Account Containers lets you keep parts of your online life separated into color-coded tabs. Cookies are separated by container, allowing you to use the web with multiple accounts and integrate Mozilla VPN for an extra layer of privacy.
* https://addons.mozilla.org/en-US/firefox/addon/multi-account-containers/

### HackTools
Hacktools, is a web extension facilitating your web application penetration tests, it includes cheat sheets as well as all the tools used during a test such as XSS payloads, Reverse shells to test your web application.
* https://addons.mozilla.org/en-US/firefox/addon/hacktools/

### Open Multiple URLs
Opens a list of URLs
* https://addons.mozilla.org/en-US/firefox/addon/open-multiple-urls/

### PwnFox
PwnFox is a Firefox/Burp extension that provide usefull tools for your security audit. Single click BurpProxy, Containers Profiles, PostMessage Logger, Toolbox injection, and Security header remover
* https://addons.mozilla.org/en-US/firefox/addon/pwnfox/

### Shodan
The Shodan plugin tells you where the website is hosted (country, city), who owns the IP and what other services/ ports are open.
* https://addons.mozilla.org/en-US/firefox/addon/shodan-addon/

### Wappalyzer
Wappalyzer is a browser extension that uncovers the technologies used on websites. It detects content management systems, eCommerce platforms, web servers, JavaScript frameworks, analytics tools and many more.
* https://addons.mozilla.org/en-US/firefox/addon/wappalyzer/

### WhatRuns
Discover what runs a website - This Firefox extension helps you identify technologies used on any website at the click of a button.
* https://addons.mozilla.org/en-US/firefox/addon/whatruns/
