# Description:
#   Deploy to deploygate with merging topic branch on Github
#
# Configuration:
#   HUBOT_GITHUB_TOKEN
#   HUBOT_GITHUB_API
#   HUBOT_GITHUB_USER
#
# Commands:
#   hubot deploygate project_name/<branch>
#
# Author:
#   ka2n

find_ci_url = (gh, repoName, branch, clbk) ->
  url = "repos/#{gh.qualified_repo(repoName)}/commits/#{branch.commit.sha}/status"
  gh.get url, (status) ->
    st = status.statuses.pop()
    clbk(st.target_url)

find_branch_by_repo = (gh, repo, name, clbk) ->
  gh.branches repo, (branches) ->
    branch = branches.filter((branch) ->
      return branch.name == name
    ).pop()
    clbk(branch, branches)

module.exports = (bot) ->
  gh = require('githubot')(bot)

  bot.respond /deploygate ([-_\.0-9a-zA-Z]+)\/([-_\.a-zA-z0-9\/]+)/i, (msg) ->
    repo = msg.match[1]
    branchName = msg.match[2]

    deployBranchName = "deploy-#{branchName}"

    find_branch_by_repo gh, repo, branchName, (baseBranch, branches) ->
      if not baseBranch
        msg.send "Branch #{branchName} not found."
        return

      # Create or fetch deploy branch
      deployBranch = branches.filter((branch) ->
        return branch.name == deployBranchName
      ).pop()

      ok = (message, deployBranch) ->
        msg.send message
        find_ci_url gh, repo, deployBranch, (url) ->
          msg.send "  on: #{url}"

      # New
      if not deployBranch
        msg.send "Create new branch #{deployBranchName} from #{branchName}."
        gh.branches(repo).create deployBranchName, from: branchName, (deployBranch) ->
          ok("done. #{deployBranch.commit.url}\nWill be deploy...", deployBranch)

      # Already merged
      else if baseBranch.commit.sha == deployBranch.commit.sha
        ok("Already merged and deployed...", deployBranch)

      # Exist and needs merge
      else
        msg.send "Merge #{branchName} into #{deployBranchName}."
        gh.branches(repo).merge branchName, into: deployBranchName, (mergeCommit) ->
          ok("done. #{mergeCommit.url}\nWill be deploy...", deployBranch)
