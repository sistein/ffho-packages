#!/usr/bin/lua

local tool = {}
local uci = require('luci.model.uci').cursor()
local json =  require 'luci.json'
local sites_json = '/lib/gluon/site-select/sites.json'

module('gluon.site_generate', package.seeall)

function get_config(file)
  local f = io.open(file)
  if f then
    local config = json.decode(f:read('*a'))
    f:close()
    return config
  end
  return nil
end

function validate_site(site_code)
  local sites = get_config(sites_json)
  for _, site in pairs(sites) do
    if site.site_code == site_code then
      return true
    end
  end
  return false
end

function force_site_code(site_code)
  if site_code then
    uci:set('currentsite', 'current', 'name', site_code)
    uci:save('currentsite')
    uci:commit('currentsite')
    return true
  end
  return false
end

function set_site_code(site_code)
  if site_code and validate_site(site_code) then
    uci:set('currentsite', 'current', 'name', site_code)
    uci:save('currentsite')
    uci:commit('currentsite')
    return true
  end
  return false
end
