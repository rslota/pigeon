[![Build Status](https://travis-ci.org/codedge-llc/pigeon.svg?branch=master)](https://travis-ci.org/codedge-llc/pigeon)
[![Hex.pm](http://img.shields.io/hexpm/v/pigeon.svg)](https://hex.pm/packages/pigeon) [![Hex.pm](http://img.shields.io/hexpm/dt/pigeon.svg)](https://hex.pm/packages/pigeon)
[![Deps Status](https://beta.hexfaktor.org/badge/all/github/codedge-llc/pigeon.svg)](https://beta.hexfaktor.org/github/codedge-llc/pigeon)
# Pigeon
HTTP2-compliant wrapper for sending iOS and Android push notifications.

## Fork information
This repo is an fork of the original project. It's mean to be used as a heart of [MongoosePush](https://github.com/esl/MongoosePush) platform. Initially, this project was lacking some features that needed to be present in order to provide complete push notifications service for XMPP server. Also, there were some performance issues, crashes and connections "lockups" under heavy loads ([MongoosePush](https://github.com/esl/MongoosePush) is load tested). Due to those issues I've heavely modified the code by introducing the following changes:

* configuration may be provided externally for convinience (e.g. dynamically by wrapping application)
* you can setup multiple pools for one push notifications provider (e.g. you can have separate pool for `:dev` and `:prod` APNS enviroments)
* timeouts are configurable 
* HTTP/2 client has been changed to `chatterbox` which was almost bug-free in terms of behaving good under heavy load
* APNS and FCM are now implemented using generic HTTP/2 worker, which decreases code complexity and maintnance cost
* support for setting default APNS topic 
* some other minor bugfiexes

## Installation
**Note: Pigeon's API will likely change until v1.0**

Add pigeon as a `mix.exs` dependency:
  ```elixir
  def deps do
    [
      {:pigeon, github: "https://github.com/rslota/pigeon"}
    ]
  end
  ```
  
After running `mix deps.get`, configure `mix.exs` to start the application automatically.
  ```elixir
  def application do
    [applications: [:pigeon]]
  end
  ```
  
## Getting Started
For usage and configuration, see the docs:
* [APNS (Apple iOS)](https://hexdocs.pm/pigeon/apns-apple-ios.html)
* [GCM (Android)](https://hexdocs.pm/pigeon/gcm-android.html)
* [ADM (Amazon Android)](https://hexdocs.pm/pigeon/adm-amazon-android.html)
