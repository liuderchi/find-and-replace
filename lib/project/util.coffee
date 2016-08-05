_ = require 'underscore-plus'
{$} = require 'atom-space-pen-views'

module.exports =
  escapeHtml: (str) ->
    @escapeNode ?= document.createElement('div')
    @escapeNode.innerText = str
    @escapeNode.innerHTML

  escapeRegex: (str) ->
    str.replace /[.?*+^$[\]\\(){}|-]/g, (match) ->
      "\\" + match

  sanitizePattern: (pattern) ->
    pattern = @escapeHtml(pattern)
    pattern.replace(/\n/g, '\\n').replace(/\t/g, '\\t')

  getReplacementResultsMessage: ({findPattern, replacePattern, replacedPathCount, replacementCount}) ->
    if replacedPathCount
      "<span class=\"text-highlight\">Replaced <span class=\"highlight-error\">#{@sanitizePattern(findPattern)}</span> with <span class=\"highlight-success\">#{@sanitizePattern(replacePattern)}</span> #{_.pluralize(replacementCount, 'time')} in #{_.pluralize(replacedPathCount, 'file')}</span>"
    else
      "<span class=\"text-highlight\">Nothing replaced</span>"

  getSearchResultsMessage: ({findPattern, matchCount, pathCount, replacedPathCount}) ->
    if matchCount
      "#{_.pluralize(matchCount, 'result')} found in #{_.pluralize(pathCount, 'file')} for <span class=\"highlight-info\">#{@sanitizePattern(findPattern)}</span>"
    else
      "No #{if replacedPathCount? then 'more' else ''} results found for '#{@sanitizePattern(findPattern)}'"

  parseSearchResult: ->
    searchResult = []
    summary = $('span.preview-count', 'div.preview-pane').text()
    searchResult.push summary, ''

    $('ol.results-view.list-tree>li.path').each ->
      path = $('span.path-name', this).text()
      matches = $('span.path-match-number', this).text()
      searchResult.push path + ' ' + matches

      $('li.search-result', this).filter(':visible').each ->
        lineNumber = $('span.line-number', this).text()
        preview = $('span.preview', this).text()
        searchResult.push '\t' + lineNumber + '\t' + preview
      searchResult.push ''
    searchResult.join('\n')
