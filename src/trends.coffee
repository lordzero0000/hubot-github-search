# Description:
#   A hubot script to show what's hot on github.
#
# Dependencies:
#   "github": "~0.2.4"
#
# Configuration:
#   None
#
# Commands:
#   hubot what's hot on github?
#
# Author:
#   lordzero0000

GitHubApi = require("github")
github = new GitHubApi(
  version: '3.0.0'
  debug: true
  protocol: 'https'
  host: process.env.GITHUB_URL
  pathPrefix: process.env.GITHUB_PREFIX
  timeout: 5000
  headers: 'user-agent': 'My-Cool-GitHub-App')

module.exports = (robot) ->
  robot.respond /what's hot on github/i, (msg) ->
    github.search.repos {
      q: 'stars:>1'
      sort: 'stars'
      order: 'desc'
      page: '1'
      per_page: '10'
    }, (err, res) ->
      if err
        msg.send "Error: #{err.message}"
      else
        list = []
        for item in res.items
          list.push "* [#{item.full_name}](#{item.html_url})"
        msg.send "The most popular repositories are:\n #{list.join("\n")}"

getUserSearch = (github, query, sort, order, page, per_page) ->
  new Promise (resolve, reject) ->
    github.search.users {
      q: query
      sort: sort
      order: order
      page: page
      per_page: per_page
    }, (err, res) ->
      if err
        reject(err)
      else
        resolve(res)
    return

getRepoSearch = (github, query, sort, order, page, per_page) ->
  new Promise (resolve, reject) ->
    github.search.repos {
      q: query
      sort: sort
      order: order
      page: page
      per_page: per_page
    }, (err, res) ->
      if err
        reject(err)
      else
        resolve(res)
    return
