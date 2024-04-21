work in progress, star and follow to track progress

![DALL·E 2024-04-20 23 27 00 - Create a digital banner for the GitHub repository named 'HackerToolkit', ensuring it mirrors the previous design closely with only one change correct](https://github.com/ChrisJr404/HackerToolkit/assets/11917633/170bf9c2-03c0-40ef-a9e9-230c76f65122)

## Welcome to the HackerToolkit 🛠️

**Your comprehensive suite for penetration testing and bug bounty hunting.**

Whether you're a seasoned penetration tester or just starting out in the world of bug bounty hunting, HackerToolkit offers a curated selection of tools designed to enhance your hacking capabilities. This repository not only organizes these tools but provides information about them.

### Features:
- **Complete Tool Listings:** Access a meticulously organized list of tools included in the `install.sh` file, each with a detailed description to help you understand and choose the right tool for the right job.
- **Quick Installation:** Get up and running quickly with our `install.sh` script that allows you to download and install all tools at once (unless noted) — streamlining your setup process and saving you valuable time.
- **Cross-Distribution Compatibility:** Originally tailored for Kali Linux, our toolkit is compatible with many other Linux distributions, ensuring flexibility regardless of your preferred environment.

### Installation Instructions:
1. **Clone the Repository:** `git clone https://github.com/ChrisJr404/HackerToolkit.git`
2. **Navigate to the Repository:** `cd HackerToolkit`
3. **Run the Installation Script:** `./install.sh`

Embrace the power of a comprehensive hacking suite with HackerToolkit. Star the repo and follow me to stay updated with the latest tools and improvements!

## Burp Suite Extensions (Doesn't Automatically Install)
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

### HTTP Request Smuggler
This is an extension for Burp Suite designed to help you launch HTTP Request Smuggling attacks. It supports scanning for Request Smuggling vulnerabilities, and also aids exploitation by handling cumbersome offset-tweaking for you.
* https://portswigger.net/bappstore/aaaa60ef945341e8a450217a54a11646

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

## Firefox Browser Extensions (Doesn't Automatically Install)
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
