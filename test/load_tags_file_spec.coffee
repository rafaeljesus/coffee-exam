fs = require 'fs'
path = require 'path'
expect = require('chai').expect
Tag = require '../lib/tag'
Report = require '../lib/report'

describe 'Load Tags File', ->
  tags = []
  jsonFiles = []

  beforeEach (done) ->
    fs.readFile 'tags.txt', 'utf8', (err, file) ->
      file.toString().split('\n').forEach (line) ->
        return  if line == ''
        tags.push line
      done()

    fs.readdir 'data', (err, files) ->
      files.map((file) ->
        path.join 'data', file
      ).forEach (file) ->
        jsonFiles.push file

  afterEach ->
    tags = []
    jsonFiles = []

  it 'when read tags.txt file then validate', (done) ->
    tags.forEach (name) ->
      expect(name).to.be.a 'string'
      expect(name).to.not.be.undefined
    done()

  it 'when read data/*.json then get only valid json', (done) ->
    tag = new Tag
    jsonFiles.forEach (file) ->
      data = fs.readFileSync file, 'utf8'
      tag.asJSON data, (err, json) ->
        return if err
        expect(json).to.have.property 'tags'
    done()

  it 'when read tags.txt then find out how many times that tag appears within data/*.json', (done) ->
    tag = new Tag tags
    jsonFiles.forEach (file) ->
      data = fs.readFileSync file, 'utf8'
      tag.asJSON data, (err, json) ->
        return if err
        tag.mapByTagName json
    report = new Report(tag.toJSON())
    report.log()
    done()
