-- rpctool.lua
-- Author: 勿言
-- LastEdit: 2024.2.14
-- Using: RPC管理的一个简单封装

local tool_context = {}
local __blank = function()end
local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()
local IsDedicated = TheNet:IsDedicated()
local IsHost =  IsServer and not IsDedicated
local IsClientCodeArea = not IsDedicated

function SetNameSpace(name)
    tool_context.namespace = name
end

function RegisterClientModRPC(name,fn)
    local namespace = tool_context.namespace
    assert(namespace,"You should set namespace first")
    assert(type(fn)=="function","Fn must be function")
    if IsClientCodeArea then
        AddClientModRPCHandler(namespace,name,fn)
    else
        AddClientModRPCHandler(namespace,name,__blank)
    end
end

function RegisterShardModRPC(name,fn)
    local namespace = tool_context.namespace
    assert(namespace,"You should set namespace first")
    assert(type(fn)=="function","Fn must be function")

    if IsServer then
        AddShardModRPCHandler(namespace, name, fn)
    end
end

function RegisterServerModRPC(name,fn)
    local namespace = tool_context.namespace
    assert(namespace,"You should set namespace first")
    assert(type(fn)=="function","Fn must be function")

    if IsServer then
        AddModRPCHandler(namespace, name, fn)
    else
        AddModRPCHandler(namespace, name, __blank)
    end
end