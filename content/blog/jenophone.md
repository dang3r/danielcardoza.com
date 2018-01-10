+++
title = "Jenophone : SMS forwarder using Twilio"
description = "Jenophone - SMS forwarder"
tags = [
  "blog",
  "project",
]
date = "2018-01-09"
+++

## Overview

When I moved to California after graduation, it became difficult to easily
communicate with my girlfriend in Canada because of telecom issues.

The crux of the problem was the following:

- My phone plan has unlimited data and unlimited texting to US, Canada phone
  numnbers.
- My girlfriend's phone plan had limited data (thank you Canadian telecoms) and
  only had unlimited texting in Canada.

I wanted to make communication easier between us, so I decided to make my own
SMS forwarding service using Twilio.

## Solution

Twilio is a company that provides programmable sms, voice and other communication
APIs.  One key feature is they allow users to register a phone number in a given
 country and hook into it via their APIs.

My proposed solution was:

- Get a phone number in Canada. This would allow both my girlfriend and I to
  text it.
- When that phone number received a text from myself, it would forward it to my
  girlfriend. And vise-versa.

Note that Twilio does give new users a certain amount of free resources, but it
is a paid service after the trial period ends.

## Implementation

To set up my Twilio phone number, I used the Twilio web-ui. After creating a
number in `Quebec`, I proceeded to create a TwiML application associated with this
number. A TwiML application allows you to configure a webserver where events are
forwarded. These events can be incoming phone calls related to the number,
incoming texts and others. Specifically, I wanted to tap into the webhook events
regarding texts.

I required a web server that could listen to these webhook events and provide
the SMS forwarding capabilties I described above. I implemented this using
`Golang` and the stand library. The code can be seen
[here](https://github.com/dang3r/jenophone).

Starting Jenophone is as simple as:

```
go build jenophone.go
./jenophone -num1=<user 1 phone number> -num2=<user 2 phone number>
```

To use, my girlfriend and I only had to start texting our provisioned Quebec number.

I decided to utilize my free `Google Compute Cloud` credits for deployment and
`LetsEncrypt` for generating the TLS keys required. I may add some basic
Terraform configuration in a future PR to ease the infrastructure work.

## Conclusion

This project was intended to solve a real world problem of mine, but to also
gain experience with the Twilio service. Friends of mine had used it extensively
for their Waterloo Fourth Year Design Project (FYDP) and loved its simplicity.

I imagine there are free or less costly services than Twilio for performing this.
However, it was a fun little project to work on and gain experience with Twilio.
