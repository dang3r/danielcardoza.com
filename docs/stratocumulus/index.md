# Stratocumulus.cloud


**TL:DR** https://stratocumulus.cloud

# Top level domains (TLD)

Every so often, I encounter a new top level domain (TLD). TLDs are at the
topmost level of domains. A few of the most common are `.com`, `.org`, `.net` and if
you are a trendy startup, `.io`. You can retrieve a full list of TLDs on
[wikipedia](https://en.wikipedia.org/wiki/Top-level_domain).

Below are some of my favourite TLDs with various subdomains.

- `.ninja`
    - `coding.ninja`
    - `sneaky.ninja`
    - `food.ninja`
- `.rocks`
    - `exercise.rocks`
    - `igneous.rocks`
    - `ilove.rocks`
- `.life`
    - `thegood.life`
    - `theeasy.life`
    - `simple.life`
- `.news`
    - `fake.news`
    - `real.news`
    - `thegood.news`

When a new TLD comes out, most of the interesting domains are snatched up quite quickly.
Sometimes, you can actually bid and pay extra to receive early access. Google did this
with `.dev` domain earlier this [year](https://insights.dice.com/2019/02/19/google-launches-dev-domain-early-access/).

# .cloud

I discovered this past month that `.cloud` is a new TLD. I tried checking a few interesting subdomains
but all were taken. These included:

- `sittingona.cloud`
- `engineer.cloud`
- `white.cloud`

I eventually tried looking up actual :cloud: types. There are ten major cloud genuses,
so I created a quick script to check their availability.

```python3
import whois

clouds = [
    "stratus",
    "stratocumulus",
    "cirrostratus",
    "cirrocumulus",
    "altocumulus",
    "cumulus",
    "cirrus",
    "altostratus",
    "nimbostratus",
    "cumulonimbus"
]

for cloud in clouds:
    domain = f"{cloud}.cloud"
    w = whois.whois(domain)
    availability = "UNAVAILABLE" if w.domain_name else "AVAILABLE"
    print(f"{domain} : {availability} ")
```

Running this yielded

```bash
$ python3 taken.py 
stratus.cloud : UNAVAILABLE 
stratocumulus.cloud : AVAILABLE 
cirrostratus.cloud : UNAVAILABLE 
cirrocumulus.cloud : UNAVAILABLE 
altocumulus.cloud : UNAVAILABLE 
cumulus.cloud : UNAVAILABLE 
cirrus.cloud : UNAVAILABLE 
altostratus.cloud : UNAVAILABLE 
nimbostratus.cloud : UNAVAILABLE 
cumulonimbus.cloud : UNAVAILABLE 
```

And that is how I decided to regiser `stratocumulus.cloud`! A few clicks later on
[Route53](https://aws.amazon.com/route53/) and I was now the proud owner of
`stratocumulus.cloud`.

I'm in love with Github Pages and how easy it is to create static websites,
so I created a placeholder website. See it at [https://stratocumulus.cloud](https://stratocumulus.cloud/)


# Tidbits about stratocumulus :cloud: s

![Cool cloud photo](https://upload.wikimedia.org/wikipedia/commons/4/4b/Above_the_Clouds.jpg)

Here are a few cool tidbits about stratocumulus clouds:

- exist below 2000m [\[0\]](https://en.wikipedia.org/wiki/Stratocumulus_cloud)
- most frequency cloud type, covering over 20% of tropical oceans [\[1\]](http://blogs.discovermagazine.com/d-brief/2019/02/26/clouds-disappear-with-climate-change/#.XQbILPmpHRY)
- climate change and the rise of carbon dioxide in the atmosphere can render these
  clouds extinct [\[2\]](https://www.livescience.com/64852-clouds-extinct-climate-change.html)
- they have an interesting cloud [symbol](https://upload.wikimedia.org/wikipedia/commons/thumb/a/aa/Clouds_CL_5.svg/1920px-Clouds_CL_5.svg.png)
- they are not a major source of precipitation but can signal worse weather is coming 
  [\[3\]](https://en.wikipedia.org/wiki/Stratocumulus_cloud)

# Future work

I want to polish off the site and reach out to any experts on stratocumulus clouds
to provide input on what should be on the site. It was a fun little project, and
made me simple it is to register a domain and create a simple site.

I'd also like to programatically determine a way to determine interesting domain names.
One idea is to use [ngrams](https://en.wikipedia.org/wiki/N-gram#Examples) to identify
common phrases that would make interesting domain names.

